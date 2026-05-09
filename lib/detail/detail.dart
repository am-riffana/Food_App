import 'package:flutter/material.dart';
import 'package:foodapp/models/resturant_model.dart';
import 'package:hive/hive.dart';

class DetailsPage extends StatelessWidget {
  final Restaurant restaurant;

  const DetailsPage({super.key, required this.restaurant});

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
            Image.network(
              restaurant.images.isNotEmpty
                  ? restaurant.images.first
                  : 'https://via.placeholder.com/300',
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      SizedBox(width: 6),
                      Text(
                        restaurant.rating,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 6),
                      Text(restaurant.distance, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Delicious food with amazing taste and fast delivery.",
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      onPressed: () {
                        int qty = 1;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
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
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom +
                                        20,
                                  ),

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        restaurant.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),

                                      Text(
                                        "Price: ₹${restaurant.price}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      SizedBox(height: 20),

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
                                            icon: Icon(Icons.remove),
                                          ),
                                          Text(
                                            "$qty",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() => qty++);
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 20),
                                      Text(
                                        "Total: ₹${restaurant.price * qty}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),

                                      SizedBox(height: 20),

                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                          ),
                                          onPressed: () {
                                            ordersBox.add({
                                              'name': restaurant.name,
                                              'image':
                                                  restaurant.images.isNotEmpty
                                                  ? restaurant.images.first
                                                  : '',
                                              'price': restaurant.price,
                                              'qty': qty,
                                            });

                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${restaurant.name} added",
                                                ),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Add To Orders",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
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

                      child: Text(
                        "Add To Orders",
                        style: TextStyle(
                          fontSize: 19,
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
