import 'package:flutter/material.dart';
import 'package:foodapp/admin/models/food_model.dart';
import 'package:foodapp/admin/services/food_service.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AdminCategoriesViewPage extends StatefulWidget {
  const AdminCategoriesViewPage({super.key});

  @override
  State<AdminCategoriesViewPage> createState() =>
      _AdminCategoriesViewPageState();
}

class _AdminCategoriesViewPageState extends State<AdminCategoriesViewPage> {
  final _supabase = Supabase.instance.client;
  final _service = FoodService();

  List<Map<String, dynamic>> allFoods = [];
  List<Map<String, dynamic>> dbCategories = [];
  List<String> categories = ['All'];
  String selectedCategory = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await loadCategories();
    await loadFoods();
  }

  Future<void> loadCategories() async {
    try {
      final data = await _supabase
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: true);

      final List<String> fromDB =
          (data as List).map((c) => c['name'].toString()).toList();

      setState(() {
        dbCategories = List<Map<String, dynamic>>.from(data);
        categories = ['All', ...fromDB];
      });
    } catch (e) {
      debugPrint('Load categories error: $e');
    }
  }

  Future<void> loadFoods() async {
    setState(() => isLoading = true);
    try {
      final data = await _supabase.from('foods').select();

      final supabaseFoods = List<Map<String, dynamic>>.from(data);

      for (var food in supabaseFoods) {
        final cat = food['category']?.toString();
        if (cat != null && !categories.contains(cat)) {
          categories.add(cat);
        }
      }

      setState(() {
        allFoods = supabaseFoods;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  List<Map<String, dynamic>> get filteredFoods {
    if (selectedCategory == 'All') return allFoods;
    return allFoods.where((f) => f['category'] == selectedCategory).toList();
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .trim()
        .split(' ')
        .map(
          (w) =>
              w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  bool isDuplicateName(String name, {String? excludeId}) {
    return allFoods.any(
      (f) =>
          f['name'].toString().trim().toLowerCase() ==
              name.trim().toLowerCase() &&
          f['id'] != excludeId,
    );
  }

  Future<bool> isDuplicateInDB(String name, {String? excludeId}) async {
    try {
      final result = await _supabase
          .from('foods')
          .select('id')
          .ilike('name', name.trim());
      final list = result as List;
      if (excludeId != null) {
        return list.any((f) => f['id'] != excludeId);
      }
      return list.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendNotificationToAllUsers(String itemName) async {
    try {
      final users = await _supabase.from('users').select('id');
      final notifications =
          (users as List)
              .map(
                (u) => {
                  'user_id': u['id'],
                  'title': 'New Item Added 🍔',
                  'body': '$itemName is now available. Order now!',
                  'type': 'new_item',
                },
              )
              .toList();
      if (notifications.isNotEmpty) {
        await _supabase.from('notifications').insert(notifications);
      }
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  void showFoodDialog({Map<String, dynamic>? food}) {
    final nameCtrl = TextEditingController(text: food?['name']);
    final descCtrl = TextEditingController(text: food?['description']);
    final priceCtrl = TextEditingController(text: food?['price']?.toString());
    final imgCtrl = TextEditingController(text: food?['image_url']);
    String? selectedCat = food?['category']?.toString();
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final bool isTablet = Responsive.isTablet(context);
        final double hPad = isTablet ? 32.0 : Responsive.w(context) * 0.05;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                left: hPad,
                right: hPad,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      food == null ? "Add New Food" : "Edit Food",
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ValueListenableBuilder(
                      valueListenable: imgCtrl,
                      builder: (_, __, ___) {
                        if (imgCtrl.text.isNotEmpty) {
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  imgCtrl.text,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Container(
                                        height: 160,
                                        color: Colors.orange.shade50,
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.orange,
                                          size: 48,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(height: 14),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),

                    _field(
                      nameCtrl,
                      "Food Name",
                      Icons.fastfood,
                      cap: TextCapitalization.words,
                    ),
                    SizedBox(height: 12),
                    _field(
                      descCtrl,
                      "Description",
                      Icons.description,
                      cap: TextCapitalization.sentences,
                    ),
                    SizedBox(height: 12),
                    _field(
                      priceCtrl,
                      "Price",
                      Icons.currency_rupee,
                      keyboard: TextInputType.number,
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedCat,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.category,
                            color: Colors.orange,
                          ),
                        ),
                        hint: Text("Select Category"),
                        items:
                            dbCategories
                                .map(
                                  (c) => DropdownMenuItem<String>(
                                    value: c['name'].toString(),
                                    child: Text(c['name'].toString()),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (val) => setSheetState(() => selectedCat = val),
                      ),
                    ),
                    SizedBox(height: 12),
                    _field(imgCtrl, "Image URL", Icons.image),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed:
                            isSaving
                                ? null
                                : () async {
                                  final name = capitalize(nameCtrl.text.trim());

                                  if (name.isEmpty) {
                                    _snack("Food name is required", Colors.red);
                                    return;
                                  }
                                  if (selectedCat == null) {
                                    _snack("Select a category", Colors.red);
                                    return;
                                  }
                                  if (isDuplicateName(
                                    name,
                                    excludeId: food?['id'],
                                  )) {
                                    _snack(
                                      '"$name" already exists.',
                                      Colors.red,
                                    );
                                    return;
                                  }

                                  setSheetState(() => isSaving = true);

                                  final existsInDB = await isDuplicateInDB(
                                    name,
                                    excludeId: food?['id'],
                                  );
                                  if (existsInDB) {
                                    setSheetState(() => isSaving = false);
                                    _snack(
                                      '"$name" already exists in DB.',
                                      Colors.red,
                                    );
                                    return;
                                  }

                                  try {
                                    if (food == null) {
                                      final newFood = FoodModel(
                                        id: const Uuid().v4(),
                                        name: name,
                                        description: capitalize(
                                          descCtrl.text.trim(),
                                        ),
                                        price:
                                            double.tryParse(priceCtrl.text) ??
                                            0,
                                        category: selectedCat!,
                                        imageUrl: imgCtrl.text.trim(),
                                        isAvailable: true,
                                      );
                                      await _service.addFood(newFood);
                                      await sendNotificationToAllUsers(name);
                                    } else {
                                      await _supabase
                                          .from('foods')
                                          .update({
                                            'name': name,
                                            'description': capitalize(
                                              descCtrl.text.trim(),
                                            ),
                                            'price':
                                                double.tryParse(
                                                  priceCtrl.text,
                                                ) ??
                                                0,
                                            'category': selectedCat,
                                            'image_url': imgCtrl.text.trim(),
                                          })
                                          .eq('id', food['id']);
                                    }

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      _snack(
                                        food == null
                                            ? "Food added!"
                                            : "Food updated!",
                                        Colors.green,
                                      );
                                    }
                                    loadFoods();
                                  } catch (e) {
                                    setSheetState(() => isSaving = false);
                                    _snack("Error: $e", Colors.red);
                                  }
                                },
                        child:
                            isSaving
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  food == null ? "Add Food" : "Update Food",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> toggleAvailability(Map<String, dynamic> food) async {
    final current = food['is_available'] ?? true;
    await _supabase
        .from('foods')
        .update({'is_available': !current})
        .eq('id', food['id']);
    loadFoods();
  }

  Future<void> deleteFood(Map<String, dynamic> food) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Delete Food"),
            content: Text('Delete "${food['name']}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text("Delete", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
    if (confirm == true) {
      await _supabase.from('foods').delete().eq('id', food['id']);
      loadFoods();
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Widget _field(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    TextCapitalization cap = TextCapitalization.none,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      textCapitalization: cap,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orange),
        hintText: hint,
        filled: true,
        fillColor: Colors.orange.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double hPad =
        isDesktop
            ? screenWidth * 0.06
            : isTablet
            ? screenWidth * 0.04
            : 16.0;

    final double chipBarHeight =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 55.0;
    final bool useGrid = isTablet || isDesktop;
    final int gridColumns = isDesktop ? 3 : 2;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Categories View",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet || isDesktop ? 22 : 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: initData,
            icon: Icon(
              Icons.refresh,
              color: Colors.orange,
              size: isTablet || isDesktop ? 28 : 24,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () => showFoodDialog(),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add Food",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: chipBarHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isSelected = selectedCategory == cat;
                final catData = dbCategories.firstWhere(
                  (c) => c['name'] == cat,
                  orElse: () => {},
                );
                final String? catImage = catData['image_url']?.toString();

                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet || isDesktop ? 16 : 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (catImage != null &&
                            catImage.isNotEmpty &&
                            cat != 'All')
                          Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: ClipOval(
                              child: Image.network(
                                catImage,
                                width: 22,
                                height: 22,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => SizedBox.shrink(),
                              ),
                            ),
                          ),
                        Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet || isDesktop ? 15 : 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 6),
          Expanded(
            child:
                isLoading
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                    : filteredFoods.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fastfood_outlined,
                            size: isTablet || isDesktop ? 80 : 60,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No items in this category",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: isTablet || isDesktop ? 18 : 14,
                            ),
                          ),
                        ],
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: loadFoods,
                      color: Colors.orange,
                      child:
                          useGrid
                              ? GridView.builder(
                                padding: EdgeInsets.fromLTRB(
                                  hPad,
                                  14,
                                  hPad,
                                  100,
                                ),
                                itemCount: filteredFoods.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: gridColumns,
                                      crossAxisSpacing: 14,
                                      mainAxisSpacing: 14,
                                      childAspectRatio: isDesktop ? 0.70 : 0.65,
                                    ),
                                itemBuilder:
                                    (_, i) => _foodCard(
                                      filteredFoods[i],
                                      isGrid: true,
                                    ),
                              )
                              : ListView.builder(
                                padding: EdgeInsets.fromLTRB(
                                  hPad,
                                  14,
                                  hPad,
                                  100,
                                ),
                                itemCount: filteredFoods.length,
                                itemBuilder:
                                    (_, i) => _foodCard(
                                      filteredFoods[i],
                                      isGrid: false,
                                    ),
                              ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _foodCard(Map<String, dynamic> food, {bool isGrid = false}) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final imageUrl = food['image_url'] ?? '';
    final bool isAvailable = food['is_available'] ?? true;

    final double imageHeight =
        isGrid
            ? (isDesktop ? 140.0 : 120.0)
            : (isDesktop
                ? 240.0
                : isTablet
                ? 210.0
                : 190.0);

    final double nameFontSize =
        isDesktop
            ? 17.0
            : isTablet
            ? 16.0
            : (isGrid ? 14.0 : 18.0);

    final double priceFontSize =
        isGrid ? (isDesktop ? 16.0 : 14.0) : (isDesktop ? 24.0 : 22.0);

    return Container(
      margin: EdgeInsets.only(bottom: isGrid ? 0 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  imageUrl,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: imageHeight,
                        color: Colors.orange.shade50,
                        child: Icon(
                          Icons.fastfood,
                          color: Colors.orange,
                          size: 48,
                        ),
                      ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    food['category'] ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isAvailable ? "Listed" : "Unlisted",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(isGrid ? 8 : 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                if (!isGrid || isDesktop)
                  Text(
                    food['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isTablet || isDesktop ? 12 : 11,
                    ),
                  ),
                SizedBox(height: 6),
                Text(
                  "₹${food['price']}",
                  style: TextStyle(
                    fontSize: priceFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => showFoodDialog(food: food),
                        icon: Icon(Icons.edit, size: 14),
                        label: Text("Edit", style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => toggleAvailability(food),
                        icon: Icon(
                          isAvailable ? Icons.visibility_off : Icons.visibility,
                          size: 14,
                        ),
                        label: Text(
                          isAvailable ? "Unlist" : "List",
                          style: TextStyle(fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => deleteFood(food),
                        icon: Icon(Icons.delete, size: 14),
                        label: Text("Delete", style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
