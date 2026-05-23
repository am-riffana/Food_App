import 'package:flutter/material.dart';
import 'package:foodapp/screens/track_order.dart';
import 'package:hive_flutter/adapters.dart';

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

  String deliveryTime(String time) {
    final orderedTime = DateTime.parse(time);

    final delivery = orderedTime.add(
      const Duration(minutes: 25),
    );

    final diff = delivery.difference(
      DateTime.now(),
    );

    if (diff.isNegative) {
      return "Delivered";
    }

    return "${diff.inMinutes} mins away";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Your Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ValueListenableBuilder(
        valueListenable: ordersBox.listenable(),

        builder: (context, box, _) {
          final items = box.values.toList();

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 90,
                    color: Colors.orange,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "No Orders Yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    "Order something tasty 🍔",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: items.length,

            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                margin: const EdgeInsets.only(
                  bottom: 16,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    /// TOP STATUS
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,

                        borderRadius:
                            const BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons.delivery_dining,
                            color: Colors.orange,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              item['orderedTime'] !=
                                      null
                                  ? deliveryTime(
                                      item[
                                          'orderedTime'],
                                    )
                                  : "Preparing",

                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.green
                                  .shade100,

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),

                            child: const Text(
                              "LIVE",

                              style: TextStyle(
                                color: Colors.green,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(14),

                      child: Row(
                        children: [

                          /// IMAGE
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            child: Image.network(
                              item['image'],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 14),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  item['name'],

                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 6),

                                const Text(
                                  "Delivered by FoodApp",

                                  style: TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),

                                const SizedBox(
                                    height: 10),

                                Row(
                                  children: [

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            10,
                                        vertical: 5,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .orange
                                            .shade50,

                                        borderRadius:
                                            BorderRadius.circular(
                                          12,
                                        ),
                                      ),

                                      child: Text(
                                        "Qty ${item['qty']}",
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.orange,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 10),

                                    Text(
                                      "₹${item['price'] * item['qty']}",

                                      style:
                                          const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 12),

                                Row(
                                  children: [

                                    Expanded(
                                      child: ElevatedButton(
                                        style:
                                            ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.orange,

                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),

                                        onPressed: () {
                                          Navigator.push(
                                            context, 
                                            MaterialPageRoute(builder: (context)=>TrackOrderPage(itemName: item['name'], image: item['image'], orderedTime: item['orderedTime']??
                                            DateTime.now().toIso8601String())));

                                        },

                                        child: const Text(
                                          "Track Order",

                                          style: TextStyle(
                                            color:
                                                Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 10),

                                    Container(
                                      decoration:
                                          BoxDecoration(
                                        border:
                                            Border.all(
                                          color:
                                              Colors.red,
                                        ),

                                        borderRadius:
                                            BorderRadius.circular(
                                          12,
                                        ),
                                      ),

                                      child: IconButton(
                                        onPressed: () {
                                          box.deleteAt(
                                            index,
                                          );
                                        },

                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color:
                                              Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}