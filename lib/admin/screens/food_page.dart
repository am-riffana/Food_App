import 'package:flutter/material.dart';
import 'package:foodapp/admin/models/food_model.dart';
import 'package:foodapp/admin/services/food_service.dart';
import 'package:uuid/uuid.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  final _service = FoodService();
  List<FoodModel> foods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFoods();
  }

  Future<void> loadFoods() async {
    final data = await _service.getFoods();
    setState(() {
      foods = data;
      isLoading = false;
    });
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void showFoodDialog({FoodModel? food}) {
    final nameCtrl = TextEditingController(text: food?.name);
    final descCtrl = TextEditingController(text: food?.description);
    final priceCtrl = TextEditingController(text: food?.price.toString());
    final catCtrl = TextEditingController(text: food?.category);
    final imgCtrl = TextEditingController(text: food?.imageUrl);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
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
                const SizedBox(height: 20),
                Text(
                  food == null ? "Add New Food" : "Edit Food",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                customField(
                    controller: nameCtrl,
                    hint: "Food Name",
                    icon: Icons.fastfood),
                const SizedBox(height: 16),
                customField(
                    controller: descCtrl,
                    hint: "Description",
                    icon: Icons.description),
                const SizedBox(height: 16),
                customField(
                    controller: priceCtrl,
                    hint: "Price",
                    icon: Icons.currency_rupee,
                    keyboard: TextInputType.number),
                const SizedBox(height: 16),
                customField(
                    controller: catCtrl,
                    hint: "Category",
                    icon: Icons.category),
                const SizedBox(height: 16),
                customField(
                    controller: imgCtrl,
                    hint: "Image URL",
                    icon: Icons.image),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () async {
                      // ✅ Validate fields
                      if (nameCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Enter food name"),
                                backgroundColor: Colors.red));
                        return;
                      }
                      if (priceCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Enter price"),
                                backgroundColor: Colors.red));
                        return;
                      }

                      try {
                        final newFood = FoodModel(
                          id: food?.id ?? const Uuid().v4(),
                          name: capitalize(nameCtrl.text.trim()),
                          description: descCtrl.text.trim(),
                          price: double.tryParse(priceCtrl.text) ?? 0,
                          category: capitalize(catCtrl.text.trim()),
                          imageUrl: imgCtrl.text.trim(),
                          isAvailable: food?.isAvailable ?? true,
                        );

                        if (food == null) {
                          await _service.addFood(newFood);
                        } else {
                          await _service.updateFood(newFood);
                        }

                        Navigator.pop(context);
                        loadFoods();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(food == null
                                ? "Food added successfully!"
                                : "Food updated successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        // ✅ Show exact error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: ${e.toString()}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      food == null ? "Add Food" : "Update Food",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget customField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orange),
        hintText: hint,
        filled: true,
        fillColor: Colors.orange.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget topCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 5),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalFoods = foods.length;
    final categories = foods.map((e) => e.category).toSet().length;
    final listed = foods.where((e) => e.isAvailable).length;
    final unlisted = foods.where((e) => !e.isAvailable).length;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Manage Foods",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: loadFoods,
            icon: const Icon(Icons.refresh, color: Colors.orange),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => showFoodDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                // TOP DASHBOARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          topCard("Foods", totalFoods.toString(),
                              Icons.fastfood, Colors.orange),
                          const SizedBox(width: 12),
                          topCard("Categories", categories.toString(),
                              Icons.category, Colors.green),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          topCard("Listed", listed.toString(),
                              Icons.visibility, Colors.blue),
                          const SizedBox(width: 12),
                          topCard("Unlisted", unlisted.toString(),
                              Icons.visibility_off, Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // FOOD LIST
                Expanded(
                  child: foods.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fastfood,
                                  size: 80, color: Colors.orange),
                              SizedBox(height: 16),
                              Text("No foods added yet",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text("Tap + to add a food item",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          itemCount: foods.length,
                          itemBuilder: (_, i) {
                            final food = foods[i];
                            return Opacity(
                              opacity: food.isAvailable ? 1.0 : 0.5,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // IMAGE
                                    ClipRRect(
                                      borderRadius:
                                          const BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        bottomLeft: Radius.circular(24),
                                      ),
                                      child: food.imageUrl.isNotEmpty
                                          ? Image.network(
                                              food.imageUrl,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => Container(
                                                width: 120,
                                                height: 120,
                                                color: Colors.orange.shade100,
                                                child: const Icon(
                                                    Icons.fastfood,
                                                    color: Colors.orange,
                                                    size: 40),
                                              ),
                                            )
                                          : Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.orange.shade100,
                                              child: const Icon(
                                                  Icons.fastfood,
                                                  color: Colors.orange,
                                                  size: 40),
                                            ),
                                    ),

                                    // DETAILS
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    food.name,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: food.isAvailable
                                                        ? Colors.green.shade50
                                                        : Colors.red.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    food.isAvailable
                                                        ? 'Listed'
                                                        : 'Unlisted',
                                                    style: TextStyle(
                                                      color: food.isAvailable
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              food.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color:
                                                      Colors.grey.shade600,
                                                  fontSize: 13),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    food.category,
                                                    style: const TextStyle(
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "₹${food.price}",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.orange),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      ElevatedButton.icon(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14)),
                                                    ),
                                                    onPressed: () =>
                                                        showFoodDialog(
                                                            food: food),
                                                    icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 16),
                                                    label: const Text("Edit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child:
                                                      ElevatedButton.icon(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          food.isAvailable
                                                              ? Colors.red
                                                              : Colors.green,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14)),
                                                    ),
                                                    onPressed: () =>
                                                        toggleAvailability(
                                                            food),
                                                    icon: Icon(
                                                      food.isAvailable
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                    label: Text(
                                                      food.isAvailable
                                                          ? "Unlist"
                                                          : "List",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor:
                                                        Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14)),
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      await _service
                                                          .deleteFood(food.id);
                                                      loadFoods();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Food deleted!"),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Error: ${e.toString()}"),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}