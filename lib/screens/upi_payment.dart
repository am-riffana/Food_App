import 'package:flutter/material.dart';
import 'package:foodapp/screens/order.dart';

class UpiPaymentPage extends StatefulWidget {
  final double total;

  const UpiPaymentPage({
    super.key,
    required this.total,
  });

  @override
  State<UpiPaymentPage> createState() =>
      _UpiPaymentPageState();
}

class _UpiPaymentPageState
    extends State<UpiPaymentPage> {

  bool isPaid = false;

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
          "UPI Payment",

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

      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(16),

          child: Container(
            width: double.infinity,

            padding:
                const EdgeInsets.all(22),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                28,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset:
                      const Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [

                /// ONLY ONE ICON
                if (isPaid)

                  Container(
                    padding:
                        const EdgeInsets.all(
                      18,
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

                      size: 70,

                      color: Colors.green,
                    ),
                  ),

                /// QR IMAGE
                if (!isPaid)

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    child: Image.asset(
                      "assets/qr.png",

                      height: 220,
                      width: 220,

                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 24),

                /// TITLE
                Text(
                  isPaid
                      ? "Payment Successful"
                      : "Pay ₹${widget.total.toStringAsFixed(2)}",

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,

                    color:
                        isPaid
                            ? Colors.green
                            : Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                /// SUBTITLE
                Text(
                  isPaid
                      ? "Your order has been placed successfully"
                      : "Scan QR using any UPI app",

                  textAlign:
                      TextAlign.center,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

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
                          : "Pay Now",

                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,

                        color:
                            Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}