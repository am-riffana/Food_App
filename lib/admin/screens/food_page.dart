import 'package:flutter/material.dart';
import 'package:foodapp/admin/models/food_model.dart';
import 'package:foodapp/admin/services/food_service.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  final _service = FoodService();
  final _supabase = Supabase.instance.client;
  List<FoodModel> foods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFoods();
  }

  Future<void> loadFoods() async {
    setState(() => isLoading = true);
    final data = await _service.getFoods();
    setState(() {
      foods = data;
      isLoading = false;
    });
  }

  // ── Every word capitalized ────────────────────────────────────────────
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .trim()
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  // ── Send notification to all users ───────────────────────────────────
  Future<void> sendNotificationToAllUsers(String itemName) async {
    try {
      final users = await _supabase.from('users').select('id');
      final notifications = (users as List)
          .map((u) => {
                'user_id': u['id'],
                'title': 'New Item Added 🍔',
                'body': '$itemName is now available. Order now!',
                'type': 'new_item',
              })
          .toList();

      if (notifications.isNotEmpty) {
        await _supabase.from('notifications').insert(notifications);
      }
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  // ── Local duplicate check ─────────────────────────────────────────────
  bool isDuplicateName(String name, {String? excludeId}) {
    return foods.any(
      (f) =>
          f.name.trim().toLowerCase() == name.trim().toLowerCase() &&
          f.id != excludeId,
    );
  }

  // ── DB duplicate check ────────────────────────────────────────────────
  Future<bool> isDuplicateInDB(String name, {String? excludeId}) async {
    try {
      final result = await _supabase
          .from('foods')
          .select('id, name')
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

  // ── Dialog ────────────────────────────────────────────────────────────
  void showFoodDialog({FoodModel? food}) {
    final nameCtrl = TextEditingController(text: food?.name);
    final descCtrl = TextEditingController(text: food?.description);
    final priceCtrl =
        TextEditingController(text: food?.price.toString());
    final catCtrl = TextEditingController(text: food?.category);
    final imgCtrl = TextEditingController(text: food?.imageUrl);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final bool isTablet = Responsive.isTablet(context);
        final double screenWidth = Responsive.w(context);
        final double hPad = isTablet ? 32.0 : screenWidth * 0.05;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                left: hPad,
                right: hPad,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      food == null ? "Add New Food" : "Edit Food",
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Image preview
                    ValueListenableBuilder(
                      valueListenable: imgCtrl,
                      builder: (_, __, ___) {
                        if (imgCtrl.text.isNotEmpty) {
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(16),
                                child: Image.network(
                                  imgCtrl.text,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(
                                    height: 160,
                                    color: Colors.orange.shade50,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.orange,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // ── Fields ──────────────────────────────────────
                    _customField(
                      nameCtrl,
                      "Food Name",
                      Icons.fastfood,
                      capitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 14),
                    _customField(
                      descCtrl,
                      "Description",
                      Icons.description,
                      capitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 14),
                    _customField(
                      priceCtrl,
                      "Price",
                      Icons.currency_rupee,
                      keyboard: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    _customField(
                      catCtrl,
                      "Category",
                      Icons.category,
                      capitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 14),
                    _customField(
                      imgCtrl,
                      "Image URL",
                      Icons.image,
                    ),
                    const SizedBox(height: 25),

                    // Save button
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
                        onPressed: isSaving
                            ? null
                            : () async {
                                final name = capitalize(
                                    nameCtrl.text.trim());

                                // ── Empty check ──────────────────────
                                if (name.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Food name is required"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // ── Local duplicate check ────────────
                                if (isDuplicateName(name,
                                    excludeId: food?.id)) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '"$name" already exists. '
                                        'Same food name is not allowed '
                                        'even in a different category.',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration:
                                          const Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }

                                setSheetState(
                                    () => isSaving = true);

                                // ── DB duplicate check ───────────────
                                final existsInDB =
                                    await isDuplicateInDB(name,
                                        excludeId: food?.id);

                                if (existsInDB) {
                                  setSheetState(
                                      () => isSaving = false);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '"$name" already exists in '
                                          'the database. Use a '
                                          'different name.',
                                        ),
                                        backgroundColor: Colors.red,
                                        duration:
                                            const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                  return;
                                }

                                final newFood = FoodModel(
                                  id: food?.id ?? const Uuid().v4(),
                                  name: name,
                                  description: capitalize(
                                      descCtrl.text.trim()),
                                  price: double.tryParse(
                                          priceCtrl.text) ??
                                      0,
                                  category: capitalize(
                                      catCtrl.text.trim()),
                                  imageUrl: imgCtrl.text.trim(),
                                  isAvailable:
                                      food?.isAvailable ?? true,
                                );

                                if (food == null) {
                                  await _service.addFood(newFood);
                                  await sendNotificationToAllUsers(
                                      name);
                                } else {
                                  await _service.updateFood(newFood);
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                                loadFoods();
                              },
                        child: isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                food == null
                                    ? "Add Food"
                                    : "Update Food",
                                style: const TextStyle(
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

  // ── Toggle availability ───────────────────────────────────────────────
  Future<void> toggleAvailability(FoodModel food) async {
    final updated = FoodModel(
      id: food.id,
      name: food.name,
      description: food.description,
      price: food.price,
      category: food.category,
      imageUrl: food.imageUrl,
      isAvailable: !food.isAvailable,
    );
    await _service.updateFood(updated);
    loadFoods();
  }

  // ── Delete with confirmation ──────────────────────────────────────────
  Future<void> deleteFood(FoodModel food) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Delete Food"),
        content: Text(
            'Are you sure you want to delete "${food.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteFood(food.id);
      loadFoods();
    }
  }

  // ── Custom text field ─────────────────────────────────────────────────
  Widget _customField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      textCapitalization: capitalization,
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

  // ── Build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double hPad = isDesktop
        ? screenWidth * 0.06
        : isTablet
            ? screenWidth * 0.04
            : screenWidth * 0.04;

    final int crossAxis = isDesktop
        ? 3
        : isTablet
            ? 2
            : 1;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Manage Foods",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet || isDesktop ? 22 : 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadFoods,
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
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Food",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : foods.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fastfood_outlined,
                        size: isTablet || isDesktop ? 100 : 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No foods added yet",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isTablet || isDesktop ? 20 : 16,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadFoods,
                  color: Colors.orange,
                  child: crossAxis == 1
                      ? ListView.builder(
                          padding: EdgeInsets.all(hPad),
                          itemCount: foods.length,
                          itemBuilder: (_, i) => _foodCard(
                              foods[i], isTablet, isDesktop),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.all(hPad),
                          itemCount: foods.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxis,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio:
                                isDesktop ? 1.1 : 0.95,
                          ),
                          itemBuilder: (_, i) => _foodCard(
                              foods[i], isTablet, isDesktop),
                        ),
                ),
    );
  }

  Widget _foodCard(
      FoodModel food, bool isTablet, bool isDesktop) {
    return Container(
      margin:
          EdgeInsets.only(bottom: isTablet || isDesktop ? 0 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20)),
            child: Image.network(
              food.imageUrl,
              height: isTablet || isDesktop ? 160 : 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: isTablet || isDesktop ? 160 : 130,
                color: Colors.orange.shade50,
                child: const Icon(Icons.fastfood,
                    color: Colors.orange, size: 48),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        food.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              isTablet || isDesktop ? 17 : 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: food.isAvailable
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        food.isAvailable ? "Listed" : "Unlisted",
                        style: TextStyle(
                          color: food.isAvailable
                              ? Colors.green
                              : Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  food.category,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: isTablet || isDesktop ? 13 : 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹${food.price}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => showFoodDialog(food: food),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Edit"),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.blue),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => toggleAvailability(food),
                    icon: Icon(
                      food.isAvailable
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 16,
                    ),
                    label: Text(
                        food.isAvailable ? "Unlist" : "List"),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.orange),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => deleteFood(food),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text("Delete"),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}