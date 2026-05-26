import 'package:flutter/material.dart';
import 'package:foodapp/payments/order_helper.dart';
import 'package:foodapp/screens/orders_screen.dart';

class UpiPaymentPage extends StatefulWidget {
  final double total;

   const  UpiPaymentPage({
    super.key,
    required this.total,
  });

  @override
  State<UpiPaymentPage> createState() => _UpiPaymentPageState();
}

class _UpiPaymentPageState extends State<UpiPaymentPage> {
  bool isPaid = false;
  bool isLoading = false;

  Future<void> saveOrderAndNavigate() async {
    setState(() => isLoading = true);
    try {
      await saveOrderToSupabase(paymentMethod: 'UPI');
    } catch (e) {
      debugPrint('Order save failed: $e');
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  OrdersPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          "UPI Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme:  IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding:  EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset:  Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPaid)
                  Container(
                    padding:  EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(Icons.check_circle,
                        size: 70, color: Colors.green),
                  ),
                if (!isPaid)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/qr.png",
                      height: 220,
                      width: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                 SizedBox(height: 24),
                Text(
                  isPaid
                      ? "Payment Successful"
                      : "Pay ₹${widget.total.toStringAsFixed(2)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : Colors.black,
                  ),
                ),
                 SizedBox(height: 10),
                Text(
                  isPaid
                      ? "Your order has been placed successfully"
                      : "Scan QR using any UPI app",
                  textAlign: TextAlign.center,
                  style:  TextStyle(color: Colors.grey, fontSize: 16),
                ),
                 SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPaid ? Colors.green : Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (isPaid) {
                              await saveOrderAndNavigate();
                            } else {
                              setState(() => isPaid = true);
                            }
                          },
                    child: isLoading
                        ?  CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isPaid ? "Done" : "Pay Now",
                            style:  TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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