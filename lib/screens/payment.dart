import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PaymentPage extends StatelessWidget {
  final double? total;

  const PaymentPage({super.key, this.total});


  void completePayment(BuildContext context) {
    final box = Hive.box('orders');

    for (int i = 0; i < box.length; i++) {
      final item = Map<String, dynamic>.from(box.getAt(i));

      box.putAt(i, {
        ...item,
        "status": "ordered",
        "orderedTime": DateTime.now().toIso8601String(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful 🎉")),
    );

    Navigator.pop(context); // back to orders
  }

  @override
  Widget build(BuildContext context) {
    String selectedMethod = "COD";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.orange,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 💰 TOTAL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "₹$total",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 💳 PAYMENT OPTIONS
            _paymentTile("Cash on Delivery"),
            _paymentTile("UPI"),
            _paymentTile("Card"),

            const Spacer(),

            /// 🔘 PAY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => completePayment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _paymentTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.payment),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }
}