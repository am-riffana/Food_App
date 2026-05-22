import 'package:flutter/material.dart';
import 'package:foodapp/screens/order.dart';

class CardPaymentPage extends StatefulWidget {
  final double total;

  const CardPaymentPage({
    super.key,
    required this.total,
  });

  @override
  State<CardPaymentPage> createState() =>
      _CardPaymentPageState();
}

class _CardPaymentPageState
    extends State<CardPaymentPage> {

  bool isPaid = false;

  final TextEditingController
      cardController =
      TextEditingController();

  final TextEditingController
      expiryController =
      TextEditingController();

  final TextEditingController
      cvvController =
      TextEditingController();

  final TextEditingController
      nameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Card Payment",

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme:
            const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            /// CARD PREVIEW
            if (!isPaid)

              Container(
                width: double.infinity,
                height: 210,

                padding:
                    const EdgeInsets.all(
                  22,
                ),

                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFFFF7A00),
                      Color(0xFFFFA726),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    28,
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Icon(
                          Icons.credit_card,
                          color: Colors.white,
                          size: 34,
                        ),

                        Icon(
                          Icons.wifi,
                          color: Colors.white,
                        ),
                      ],
                    ),

                    const Spacer(),

                    Text(
                      cardController
                              .text
                              .isEmpty
                          ? "**** **** **** 4589"
                          : cardController.text,

                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        letterSpacing: 2,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            const Text(
                              "CARD HOLDER",

                              style: TextStyle(
                                color:
                                    Colors.white70,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(
                                height: 4),

                            Text(
                              nameController
                                      .text
                                      .isEmpty
                                  ? "YOUR NAME"
                                  : nameController
                                      .text,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            const Text(
                              "EXPIRES",

                              style: TextStyle(
                                color:
                                    Colors.white70,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(
                                height: 4),

                            Text(
                              expiryController
                                      .text
                                      .isEmpty
                                  ? "08/28"
                                  : expiryController
                                      .text,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            /// SUCCESS ICON
            if (isPaid)

              Container(
                padding:
                    const EdgeInsets.all(
                  22,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.green
                      .shade100,

                  shape:
                      BoxShape.circle,
                ),

                child: const Icon(
                  Icons.check_circle,

                  size: 90,

                  color: Colors.green,
                ),
              ),

            const SizedBox(height: 24),

            /// SUCCESS TEXT
            if (isPaid)

              Column(
                children: const [

                  Text(
                    "Payment Successful",

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Your order has been placed successfully",

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

            /// PAYMENT FORM
            if (!isPaid)

              Container(
                margin:
                    const EdgeInsets.only(
                  top: 24,
                ),

                padding:
                    const EdgeInsets.all(
                  20,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    26,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    TextField(
                      controller:
                          cardController,

                      keyboardType:
                          TextInputType.number,

                      decoration:
                          InputDecoration(
                        hintText:
                            "Card Number",

                        prefixIcon:
                            const Icon(
                          Icons.credit_card,
                        ),

                        filled: true,
                        fillColor:
                            Colors.grey
                                .shade100,

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),

                      onChanged: (_) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [

                        Expanded(
                          child: TextField(
                            controller:
                                expiryController,

                            decoration:
                                InputDecoration(
                              hintText:
                                  "MM/YY",

                              filled: true,

                              fillColor:
                                  Colors.grey
                                      .shade100,

                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),

                                borderSide:
                                    BorderSide.none,
                              ),
                            ),

                            onChanged: (_) {
                              setState(() {});
                            },
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: TextField(
                            controller:
                                cvvController,

                            keyboardType:
                                TextInputType.number,

                            decoration:
                                InputDecoration(
                              hintText:
                                  "CVV",

                              filled: true,

                              fillColor:
                                  Colors.grey
                                      .shade100,

                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),

                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller:
                          nameController,

                      decoration:
                          InputDecoration(
                        hintText:
                            "Card Holder Name",

                        prefixIcon:
                            const Icon(
                          Icons.person,
                        ),

                        filled: true,

                        fillColor:
                            Colors.grey
                                .shade100,

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),

                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 28),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      isPaid
                          ? Colors.green
                          : Colors.orange,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),

                onPressed: () {

                  if (isPaid) {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            const OrdersPage(),
                      ),
                    );

                  } else {

                    setState(() {
                      isPaid = true;
                    });

                  }

                },

                child: Text(
                  isPaid
                      ? "Done"
                      : "Pay ₹${widget.total.toStringAsFixed(2)}",

                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,

                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}