import 'package:flutter/material.dart';

class CashPaymentPage extends StatelessWidget {
  final double total;

  const CashPaymentPage({
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
          "Cash On Delivery",
        ),

        backgroundColor:
            Colors.white,

        foregroundColor:
            Colors.black,
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Container(
          width: double.infinity,

          padding:
              const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              22,
            ),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [

              const Icon(
                Icons.delivery_dining,
                size: 90,
                color: Colors.orange,
              ),

              const SizedBox(height: 16),

              Text(
                "Pay ₹${total.toStringAsFixed(2)} on delivery",

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Please keep exact change ready for faster delivery.",
                textAlign:
                    TextAlign.center,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange,
                  ),

                  onPressed: () {},

                  child: const Text(
                    "Confirm Order",

                    style: TextStyle(
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
      ),
    );
  }
}