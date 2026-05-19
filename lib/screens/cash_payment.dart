import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
class CodPayment extends StatelessWidget {

  final double total;

  const CodPayment({super.key, required this.total});

  void confirmOrder(BuildContext context) {

    final box = Hive.box('orders');

    for (int i = 0; i < box.length; i++) {

      final item = Map<String, dynamic>.from(box.getAt(i));

      box.putAt(i, {
        ...item,
        "status": "ordered",
        "orderedTime": DateTime.now().toIso8601String(),
      });
    }
    Navigator.popUntil(context, (route) => route.isFirst);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Cash on Delivery"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
           SizedBox(height: 30),
           Icon(Icons.delivery_dining, size: 100, color: Colors.orange),
           SizedBox(height: 20),

           Text(
            "Pay when your order arrives 🚚",
            style: TextStyle(fontSize: 18),
          ),
           Spacer(),

          Padding(
            padding:  EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => confirmOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize:  Size(double.infinity, 50),
              ),
              child:  Text("Confirm Order"),
            ),
          )
        ],
      ),
    );
  }
}