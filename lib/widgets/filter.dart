import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final String currentFilter;

  const FilterPage({
    super.key,
    required this.currentFilter,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.currentFilter;
  }

  Widget filterTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selected == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selected = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade200,
            width: 1.4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF7A00), Color(0xFFFFA726)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text(
          "Filters",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    filterTile(
                      title: "All",
                      subtitle: "Show all food items",
                      icon: Icons.fastfood,
                    ),
                    filterTile(
                      title: "Low Price",
                      subtitle: "Items below ₹150",
                      icon: Icons.currency_rupee,
                    ),
                    filterTile(
                      title: "High Rating",
                      subtitle: "4.5+ rated foods",
                      icon: Icons.star,
                    ),
                    filterTile(
                      title: "Premium",
                      subtitle: "Luxury food items",
                      icon: Icons.workspace_premium,
                    ),
                    filterTile(
                      title: "Fast Delivery",
                      subtitle: "Delivered within 20 mins",
                      icon: Icons.delivery_dining,
                    ),
                    filterTile(
                      title: "Veg Only",
                      subtitle: "Pure vegetarian foods",
                      icon: Icons.eco,
                    ),
                    filterTile(
                      title: "Non Veg",
                      subtitle: "Chicken & meat items",
                      icon: Icons.restaurant,
                    ),
                    filterTile(
                      title: "Spicy",
                      subtitle: "Hot & spicy foods",
                      icon: Icons.local_fire_department,
                    ),
                    filterTile(
                      title: "Best Seller",
                      subtitle: "Most ordered foods",
                      icon: Icons.local_offer,
                    ),
                    filterTile(
                      title: "Healthy",
                      subtitle: "Healthy & low calorie",
                      icon: Icons.favorite,
                    ),
                    filterTile(
                      title: "Desserts",
                      subtitle: "Ice creams & sweets",
                      icon: Icons.icecream,
                    ),
                    filterTile(
                      title: "New Arrivals",
                      subtitle: "Recently added items",
                      icon: Icons.new_releases,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, selected);
                },
                child: const Text(
                  "Apply Filter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}