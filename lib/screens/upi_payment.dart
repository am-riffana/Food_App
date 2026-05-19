import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UpiPayment extends StatelessWidget {
  final double total;

  const UpiPayment({super.key, required this.total});

  void pay(BuildContext context) {
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
        title: Text("UPI Payment"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration
              (labelText: "Enter UPI ID")),

            Spacer(),

            ElevatedButton(
              onPressed: () => pay(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Pay via UPI"),
            ),
          ],
        ),
      ),
    );
  }
}
