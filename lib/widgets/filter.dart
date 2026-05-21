import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final Function(String) onSelected;
  final String currentFilter;

  const FilterPage({
    super.key,
    required this.onSelected,
    required this.currentFilter,
  });

  @override
  State<FilterPage> createState() =>
      _FilterPageState();
}

class _FilterPageState
    extends State<FilterPage> {

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

    bool isSelected =
        selected == title;

    return GestureDetector(
      onTap: () {

        setState(() {
          selected = title;
        });

      },

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 250,
        ),

        margin:
            const EdgeInsets.only(
          bottom: 16,
        ),

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(
                  0xFFFFF3E0,
                )
              : Colors.white,

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          border: Border.all(
            color: isSelected
                ? Colors.orange
                : Colors.grey.shade200,

            width: 1.4,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black12,

              blurRadius: 8,

              offset:
                  const Offset(
                0,
                4,
              ),
            ),
          ],
        ),

        child: Row(
          children: [

            /// ICON
            Container(
              height: 58,
              width: 58,

              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFFFF7A00),
                    Color(0xFFFFA726),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(
                    title,

                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 5),

                  Text(
                    subtitle,

                    style:
                        const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            /// CHECK ICON
            AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 250,
              ),

              height: 28,
              width: 28,

              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.orange
                    : Colors.transparent,

                shape: BoxShape.circle,
              ),

              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color:
                          Colors.white,
                      size: 18,
                    )
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
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor:
            Colors.orange,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Filters",

          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.all(
            16,
          ),

          child: Column(
            children: [

              /// ALL
              filterTile(
                title: "All",
                subtitle:
                    "Show all food items",
                icon:
                    Icons.fastfood,
              ),

              /// LOW PRICE
              filterTile(
                title: "Low Price",
                subtitle:
                    "Items below ₹150",
                icon:
                    Icons.currency_rupee,
              ),

              /// HIGH RATING
              filterTile(
                title:
                    "High Rating",
                subtitle:
                    "4.5+ rated foods",
                icon: Icons.star,
              ),

              /// PREMIUM
              filterTile(
                title: "Premium",
                subtitle:
                    "Luxury food items",
                icon:
                    Icons.workspace_premium,
              ),

              /// FAST DELIVERY
              filterTile(
                title:
                    "Fast Delivery",
                subtitle:
                    "Delivered within 20 mins",
                icon:
                    Icons.delivery_dining,
              ),

              /// VEG
              filterTile(
                title: "Veg Only",
                subtitle:
                    "Pure vegetarian foods",
                icon: Icons.eco,
              ),

              /// NON VEG
              filterTile(
                title: "Non Veg",
                subtitle:
                    "Chicken & meat items",
                icon:
                    Icons.restaurant,
              ),

              /// SPICY
              filterTile(
                title: "Spicy",
                subtitle:
                    "Hot & spicy foods",
                icon:
                    Icons.local_fire_department,
              ),

              /// BEST SELLER
              filterTile(
                title:
                    "Best Seller",
                subtitle:
                    "Most ordered foods",
                icon:
                    Icons.local_offer,
              ),

              /// HEALTHY
              filterTile(
                title: "Healthy",
                subtitle:
                    "Healthy & low calorie",
                icon:
                    Icons.favorite,
              ),

              /// DESSERTS
              filterTile(
                title: "Desserts",
                subtitle:
                    "Ice creams & sweets",
                icon:
                    Icons.icecream,
              ),

              /// NEW ARRIVALS
              filterTile(
                title:
                    "New Arrivals",
                subtitle:
                    "Recently added items",
                icon:
                    Icons.new_releases,
              ),

              const SizedBox(
                  height: 20),

              /// APPLY BUTTON
              SizedBox(
                width:
                    double.infinity,

                height: 58,

                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),

                  onPressed: () {

                    widget.onSelected(
                      selected,
                    );

                    Navigator.pop(
                      context,
                    );

                  },

                  child: const Text(
                    "Apply Filter",

                    style: TextStyle(
                      color:
                          Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  height: 25),
            ],
          ),
        ),
      ),
    );
  }
}