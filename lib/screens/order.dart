import 'package:flutter/material.dart';
import 'package:foodapp/screens/payment.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final Box ordersBox = Hive.box('orders');

  void placeOrder() {
    for (int i = 0; i < ordersBox.length; i++) {
      final item = Map<String, dynamic>.from(ordersBox.getAt(i));

      ordersBox.putAt(i, {
        ...item,
        "status": "ordered",
        "orderedTime": DateTime.now().toIso8601String(),
      });
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Order Placed 🎉")));
  }

  String getRemainingTime(String time) {
    final orderedTime = DateTime.parse(time);
    final deliveryTime = orderedTime.add(const Duration(minutes: 20));
    final diff = deliveryTime.difference(DateTime.now());

    if (diff.isNegative) return "Arrived ✅";

    final minutes = diff.inMinutes;
    final seconds = diff.inSeconds % 60;

    return "Arriving in $minutes:${seconds.toString().padLeft(2, '0')} min";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),

      body: ValueListenableBuilder<Box>(
        valueListenable: ordersBox.listenable(),

        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No Orders Yet 😔",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          double total = 0;

          for (int i = 0; i < box.length; i++) {
            final item = Map<String, dynamic>.from(box.getAt(i));
            total += (item['price'] ?? 0) * (item['qty'] ?? 0);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: box.length,

                  itemBuilder: (context, index) {
                    final item = Map<String, dynamic>.from(box.getAt(index));

                    final int price = item['price'] ?? 0;
                    final int qty = item['qty'] ?? 1;
                    final status = item['status'] ?? "cart";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          /// IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item['image'] ?? '',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),
                                Text("Price: ₹$price"),
                                Text("Qty: $qty"),

                                const SizedBox(height: 6),

                                if (status == "ordered" &&
                                    item['orderedTime'] != null)
                                  Text(
                                    getRemainingTime(item['orderedTime']),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                Text(
                                  "Total: ₹${price * qty}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ❌ DELETE BUTTON (NEW)
                          IconButton(
                            onPressed: () {
                              box.deleteAt(index);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Item Deleted 🗑️"),
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// PLACE ORDER BUTTON
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                ),

                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentPage(total: total),
                        ),
                      );
                    },

                    child: const Text(
                      "Place Order",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
