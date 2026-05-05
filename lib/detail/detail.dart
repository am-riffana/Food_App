import 'package:flutter/material.dart';
import 'package:foodapp/models/resturant_model.dart';
import 'package:hive/hive.dart';

class DetailsPage extends StatelessWidget {
  final Restaurant restaurant;

  const DetailsPage({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final ordersBox = Hive.box('orders');

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(restaurant.name),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 IMAGE (SAFE)
            Image.network(
              restaurant.images.isNotEmpty
                  ? restaurant.images.first
                  : 'https://via.placeholder.com/300',
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🍔 NAME
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// ⭐ RATING
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text(
                        restaurant.rating,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// 📍 DISTANCE
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(
                        restaurant.distance,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 📝 DESCRIPTION
                  const Text(
                    "Delicious food with amazing taste and fast delivery.",
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),

                  const SizedBox(height: 30),

                  /// 🛒 BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      onPressed: () {
                        int qty = 1;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),

                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 20,
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        20,
                                  ),

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /// TITLE
                                      Text(
                                        restaurant.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      /// PRICE
                                      Text(
                                        "Price: ₹${restaurant.price}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      /// QUANTITY
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (qty > 1) {
                                                setState(() => qty--);
                                              }
                                            },
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Text(
                                            "$qty",
                                            style: const TextStyle(
                                                fontSize: 18),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() => qty++);
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20),

                                      /// TOTAL
                                      Text(
                                        "Total: ₹${restaurant.price * qty}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      /// ADD BUTTON
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 14),
                                          ),
                                          onPressed: () {
                                            ordersBox.add({
                                              'name': restaurant.name,
                                              'image': restaurant.images.isNotEmpty
                                                  ? restaurant.images.first
                                                  : '',
                                              'price': restaurant.price,
                                              'qty': qty,
                                            });

                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${restaurant.name} added",
                                                ),
                                                duration:
                                                    const Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Add To Orders",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },

                      child: const Text(
                        "Add To Orders",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}