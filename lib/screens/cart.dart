import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartBox = Hive.box('cart');

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.orange,
      ),

      body: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),

        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return  Center(
              child: Text("Cart is Empty"),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final item = box.getAt(index);

                    return ListTile(
                      leading: Image.network(item['image']),
                      title: Text(item['name']),
                      subtitle: Text(item['rating']),
                      trailing: IconButton(
                        icon:  Icon(Icons.delete),
                        onPressed: () => box.deleteAt(index),
                      ),
                    );
                  },
                ),
              ),

              /// 🔥 PLACE ORDER BUTTON
              Padding(
                padding:  EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize:  Size(double.infinity, 50),
                  ),

                  onPressed: () {
                    final ordersBox = Hive.box('orders');

                    /// MOVE ITEMS
                    for (var item in cartBox.values) {
                      ordersBox.add(item);
                    }

                    cartBox.clear();

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title:  Text("Order Placed 🎉"),
                        content: const Text("Your order is successful"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // close dialog
                              Navigator.pop(context); // back to home
                            },
                            child: const Text("OK"),
                          )
                        ],
                      ),
                    );
                  },

                  child:  Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}