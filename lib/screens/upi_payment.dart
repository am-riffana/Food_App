import 'package:flutter/material.dart';

class UpiPaymentPage extends StatelessWidget {
  final double total;

  const UpiPaymentPage({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text(
          "UPI Payment",
        ),

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

                  const Icon(
                    Icons.qr_code,
                    size: 100,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Pay ₹${total.toStringAsFixed(2)}",

                    style:
                        const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Use any UPI app to complete payment",
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green,
                      ),

                      onPressed: () {},

                      child: const Text(
                        "Pay Now",
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              Colors.white,
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