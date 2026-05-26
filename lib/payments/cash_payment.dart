import 'package:flutter/material.dart';
import 'package:foodapp/payments/order_helper.dart';
import 'package:foodapp/screens/orders_screen.dart';

class CashPaymentPage extends StatefulWidget {
  final double total;

  const CashPaymentPage({super.key, required this.total});

  @override
  State<CashPaymentPage> createState() => _CashPaymentPageState();
}

class _CashPaymentPageState extends State<CashPaymentPage> {
  bool isConfirmed = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Cash On Delivery",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        isConfirmed
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isConfirmed ? Icons.check_circle : Icons.delivery_dining,
                    size: 80,
                    color: isConfirmed ? Colors.green : Colors.orange,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  isConfirmed
                      ? "Order Confirmed"
                      : "Pay ₹${widget.total.toStringAsFixed(2)} on Delivery",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isConfirmed ? Colors.green : Colors.black,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  isConfirmed
                      ? "Your order has been placed successfully"
                      : "Please keep exact change ready for faster delivery.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(height: 30),
                if (!isConfirmed)
                  Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Cash payment will be collected by the delivery partner.",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isConfirmed ? Colors.green : Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              if (isConfirmed) {
                                setState(() => isLoading = true);
                                try {
                                  await saveOrderToSupabase(
                                    paymentMethod: 'Cash on Delivery',
                                  );
                                } catch (e) {
                                  debugPrint('Order save failed: $e');
                                }
                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrdersPage(),
                                    ),
                                  );
                                }
                              } else {
                                setState(() => isConfirmed = true);
                              }
                            },
                    child:
                        isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              isConfirmed ? "Done" : "Confirm Order",
                              style: TextStyle(
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
