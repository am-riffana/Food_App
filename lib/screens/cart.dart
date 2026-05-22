import 'package:flutter/material.dart';
import 'package:foodapp/screens/payment.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box ordersBox;

  @override
  void initState() {
    super.initState();
    ordersBox = Hive.box('orders');
  }

  double get totalPrice {
    double total = 0;

    for (var item in ordersBox.values) {
      total += (item['price'] * item['qty']);
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              ordersBox.clear();
              setState(() {});
            },

            child: const Text(
              "Clear",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: ordersBox.listenable(),

        builder: (context, Box box, _) {

          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Container(
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.shopping_cart,
                      size: 70,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // const Text(
                  //   "Your Cart is Empty",
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),

                  // const SizedBox(height: 10),

                  const Text(
                    "Add delicious food 🍔",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [

              /// CART ITEMS
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: box.length,

                  itemBuilder: (context, index) {

                    final item = box.getAt(index);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(24),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [

                          /// IMAGE
                        SizedBox(
  height: 140, // fixed height for all images
  width: double.infinity,
  child: ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
    child: Image.network(
      item["image"],
      fit: BoxFit.cover,
    ),
  ),
),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Text(
                                  item['name'],

                                  maxLines: 1,

                                  overflow:
                                      TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  "Fast Delivery",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [

                                    Text(
                                      "₹${item['price']}",

                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const Spacer(),

                                    /// QTY
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),

                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.orange,
                                        ),

                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),

                                      child: Row(
                                        children: [

                                          GestureDetector(
                                            onTap: () {

                                              if (item['qty'] > 1) {

                                                item['qty']--;

                                                box.putAt(
                                                  index,
                                                  item,
                                                );

                                                setState(() {});
                                              }
                                            },

                                            child: const Icon(
                                              Icons.remove,
                                              size: 18,
                                            ),
                                          ),

                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),

                                            child: Text(
                                              item['qty'].toString(),

                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {

                                              item['qty']++;

                                              box.putAt(
                                                index,
                                                item,
                                              );

                                              setState(() {});
                                            },

                                            child: const Icon(
                                              Icons.add,
                                              size: 18,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                GestureDetector(
                                  onTap: () {

                                    box.deleteAt(index);

                                    setState(() {});
                                  },

                                  child: const Row(
                                    children: [

                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),

                                      SizedBox(width: 5),

                                      Text(
                                        "Remove",

                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight:
                                              FontWeight.w600,
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
                padding: const EdgeInsets.all(20),

                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),

                child: Column(
                  children: [

                    billRow(
                      "Item Total",
                      "₹${totalPrice.toStringAsFixed(0)}",
                    ),

                    const SizedBox(height: 12),

                    billRow(
                      "Delivery Fee",
                      "₹40",
                    ),

                    const SizedBox(height: 12),

                    billRow(
                      "Taxes & Charges",
                      "₹20",
                    ),

                    const Divider(height: 30),

                    billRow(
                      "To Pay",
                      "₹${(totalPrice + 60).toStringAsFixed(0)}",
                      isBold: true,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),

                        onPressed: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentPage(
                                total: totalPrice + 60,
                              ),
                            ),
                          );
                        },

                        child: Text(
                          "Proceed to Pay • ₹${(totalPrice + 60).toStringAsFixed(0)}",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
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

            fontWeight:
                isBold
                    ? FontWeight.bold
                    : FontWeight.w500,
          ),
        ),

        Text(
          value,

          style: TextStyle(
            fontSize: 16,

            fontWeight:
                isBold
                    ? FontWeight.bold
                    : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}