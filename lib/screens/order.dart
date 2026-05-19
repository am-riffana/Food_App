import 'package:flutter/material.dart';
import 'package:foodapp/screens/payment.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}
class _OrdersPageState extends State<OrdersPage> {

  late Box ordersBox;

  @override
  void initState() {
    super.initState();
    ordersBox = Hive.box('orders');
  }
  String getRemainingTime(String time) {

    final orderedTime = DateTime.parse(time);
    final deliveryTime = orderedTime.add( Duration(minutes: 20));
    final diff = deliveryTime.difference(DateTime.now());

    if (diff.isNegative) return "Delivered";

    final minutes = diff.inMinutes;
    final seconds = diff.inSeconds % 60;

    return "$minutes:${seconds.toString().padLeft(2, '0')} min";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title:  Text("  Your Orders"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: ordersBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return  Center(
              child: Text(
                " empty 🛒",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          double total = 0;
          List items = [];
          for (int i = 0; i < box.length; i++) {
            final data = box.getAt(i);
            if (data is Map) {
              final item = Map<String, dynamic>.from(data);
              items.add(item);
              total += (item['price'] ?? 0) * (item['qty'] ?? 0);
            }
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:  EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final int price = item['price'] ?? 0;
                    final int qty = item['qty'] ?? 1;
                    final status = item['status'] ?? "cart";
                    return Container(
                      margin:  EdgeInsets.only(bottom: 12),
                      padding:  EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow:  [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              item['image'] ?? '',
                              width: 85,
                              height: 85,
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
                                  style:  TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                 SizedBox(height: 6),
                                Text(
                                  "₹$price x $qty",
                                  style:  TextStyle(color: Colors.grey),
                                ),
                                 SizedBox(height: 6),
                                Container(
                                  padding:  EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: status == "ordered"
                                        ? Colors.green.shade100
                                        : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    status == "ordered"
                                        ? "Ordered"
                                        : "In Cart",
                                    style: TextStyle(
                                      color: status == "ordered"
                                          ? Colors.green
                                          : Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                 SizedBox(height: 6),
                                Text(
                                  "Total: ₹${price * qty}",
                                  style:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (status == "ordered" &&
                                    item['orderedTime'] != null)
                                  Text(
                                    "Delivery: ${getRemainingTime(item['orderedTime'])}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              box.deleteAt(index);
                            },
                            icon:  Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:  EdgeInsets.all(16),
                decoration:  BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "Total Price",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "₹${total.toStringAsFixed(0)}",
                          style:  TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:  EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 14,
                        ),
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
                      child:  Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                
              ),
            ],
          );
        },
      ),
    );
  }
}