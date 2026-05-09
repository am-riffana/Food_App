import 'package:flutter/material.dart';
import 'package:foodapp/screens/payment.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    ).showSnackBar(SnackBar(content: Text("Order Placed 🎉")));
  }

  String getRemainingTime(String time) {
    final orderedTime = DateTime.parse(time);
    final deliveryTime = orderedTime.add(Duration(minutes: 20));
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
        title: Text("My Orders"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),

      body: ValueListenableBuilder<Box>(
        valueListenable: ordersBox.listenable(),

        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
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
                  padding: EdgeInsets.all(16),
                  itemCount: box.length,

                  itemBuilder: (context, index) {
                    final item = Map<String, dynamic>.from(box.getAt(index));

                    final int price = item['price'] ?? 0;
                    final int qty = item['qty'] ?? 1;
                    final status = item['status'] ?? "cart";

                    return Container(
                      margin: EdgeInsets.only(bottom: 14),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item['image'] ?? '',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 6),
                                Text("Price: ₹$price"),
                                Text("Qty: $qty"),

                                SizedBox(height: 6),

                                if (status == "ordered" &&
                                    item['orderedTime'] != null)
                                  Text(
                                    getRemainingTime(item['orderedTime']),
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                Text(
                                  "Total: ₹${price * qty}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              box.deleteAt(index);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Item Deleted 🗑️")),
                              );
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                ),

                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16),
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

                    child: Text(
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
