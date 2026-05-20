import 'package:flutter/material.dart';

class CardPaymentPage extends StatelessWidget {
  final double total;

  const CardPaymentPage({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        title:
            const Text("Card Payment"),

        backgroundColor:
            Colors.white,

        foregroundColor:
            Colors.black,
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            Container(
              padding:
                  const EdgeInsets.all(
                18,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Column(
                children: [

                  TextField(
                    decoration:
                        InputDecoration(
                      hintText:
                          "Card Number",

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [

                      Expanded(
                        child: TextField(
                          decoration:
                              InputDecoration(
                            hintText:
                                "MM/YY",

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: TextField(
                          decoration:
                              InputDecoration(
                            hintText: "CVV",

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    decoration:
                        InputDecoration(
                      hintText:
                          "Card Holder Name",

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),

                   SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.orange,
                      ),

                      onPressed: () {
                        
                        
                      },

                      child: Text(
                        "Pay ₹${total.toStringAsFixed(2)}",

                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}