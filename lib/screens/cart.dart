import 'package:flutter/material.dart';
import 'package:foodapp/screens/payment.dart';
import 'package:hive_flutter/adapters.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() =>
      _CartPageState();
}

class _CartPageState
    extends State<CartPage> {
  late Box ordersBox;

  @override
  void initState() {
    super.initState();
    ordersBox = Hive.box('orders');
  }

  double get totalPrice {
    double total = 0;

    for (var item in ordersBox.values) {
      total +=
          (item['price'] * item['qty']);
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              ordersBox.clear();
            },

            child: const Text(
              "Clear All",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable:
            ordersBox.listenable(),

        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 90,
                    color: Colors.orange,
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Your cart is empty",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Add delicious food to cart 🍔",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  itemCount: box.length,

                  itemBuilder:
                      (context, index) {
                    final item =
                        box.getAt(index);

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 14,
                      ),

                      padding:
                          const EdgeInsets.all(
                        12,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

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

                          const SizedBox(
                              width: 14),

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
                                    fontSize:
                                        17,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                        6),

                                const Text(
                                  "Fast Delivery",
                                  style: TextStyle(
                                    color:
                                        Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                        10),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,

                                  children: [
                                    Text(
                                      "₹${item['price']}",

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.orange,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize:
                                            18,
                                      ),
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            10,
                                        vertical:
                                            6,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        border:
                                            Border.all(
                                          color: Colors
                                              .orange,
                                        ),

                                        borderRadius:
                                            BorderRadius.circular(
                                          10,
                                        ),
                                      ),

                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap:
                                                () {
                                              if (item['qty'] >
                                                  1) {
                                                item['qty']--;

                                                box.putAt(
                                                  index,
                                                  item,
                                                );

                                                setState(
                                                    () {});
                                              }
                                            },

                                            child:
                                                const Icon(
                                              Icons
                                                  .remove,
                                              size:
                                                  18,
                                            ),
                                          ),

                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal:
                                                  12,
                                            ),

                                            child:
                                                Text(
                                              "${item['qty']}",

                                              style:
                                                  const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:
                                                () {
                                              item['qty']++;

                                              box.putAt(
                                                index,
                                                item,
                                              );

                                              setState(
                                                  () {});
                                            },

                                            child:
                                                const Icon(
                                              Icons
                                                  .add,
                                              size:
                                                  18,
                                              color:
                                                  Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height:
                                        10),

                                GestureDetector(
                                  onTap: () {
                                    box.deleteAt(
                                      index,
                                    );
                                  },

                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color:
                                            Colors.red,
                                        size:
                                            18,
                                      ),

                                      SizedBox(
                                          width:
                                              4),

                                      Text(
                                        "Remove",

                                        style:
                                            TextStyle(
                                          color:
                                              Colors.red,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
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
                ),
              ),

              /// BILL SECTION
              Container(
                padding:
                    const EdgeInsets.all(20),

                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),

                child: Column(
                  children: [
                    billRow(
                      "Item Total",
                      "₹${totalPrice.toStringAsFixed(0)}",
                    ),

                    const SizedBox(height: 10),

                    billRow(
                      "Delivery Fee",
                      "₹40",
                    ),

                    const SizedBox(height: 10),

                    billRow(
                      "Taxes",
                      "₹20",
                    ),

                    const Divider(
                      height: 30,
                    ),

                    billRow(
                      "To Pay",
                      "₹${(totalPrice + 60).toStringAsFixed(0)}",
                      isBold: true,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),

                        onPressed: () {
                          Navigator.push(
                            context,
                             MaterialPageRoute(builder: (context)=> PaymentPage(total: totalPrice)));
                        },

                        child: Text(
                          "Proceed • ₹${(totalPrice + 60).toStringAsFixed(0)}",

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
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

  Widget billRow(
    String title,
    String value, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: TextStyle(
            fontSize: 16,

            fontWeight: isBold
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),

        Text(
          value,

          style: TextStyle(
            fontSize: 16,

            fontWeight: isBold
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}