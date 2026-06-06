import 'package:flutter/material.dart';
import 'package:foodapp/payments/order_helper.dart';
import 'package:foodapp/screens/orders_screen.dart';
import 'package:foodapp/widgets/responsive.dart';

class UpiPaymentPage extends StatefulWidget {
  final double total;

  const UpiPaymentPage({super.key, required this.total});

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
        MaterialPageRoute(builder: (_) => OrdersPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final double cardWidth =
        isDesktop
            ? 480.0
            : isTablet
            ? 440.0
            : double.infinity;

    final double cardPadding =
        isDesktop
            ? 36.0
            : isTablet
            ? 28.0
            : 22.0;

    final double qrSize =
        isDesktop
            ? 280.0
            : isTablet
            ? 250.0
            : 220.0;

    final double successIconSize =
        isDesktop
            ? 90.0
            : isTablet
            ? 80.0
            : 70.0;

    final double successIconPad =
        isDesktop
            ? 26.0
            : isTablet
            ? 22.0
            : 18.0;

    final double titleFontSize =
        isDesktop
            ? 32.0
            : isTablet
            ? 30.0
            : 28.0;

    final double subtitleFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;

    final double btnFontSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 19.0
            : 18.0;

    final double btnHeight =
        isDesktop
            ? 64.0
            : isTablet
            ? 62.0
            : 58.0;

    final double appBarFontSize =
        isDesktop
            ? 22.0
            : isTablet
            ? 20.0
            : 18.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "UPI Payment",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: appBarFontSize,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            isDesktop
                ? 32
                : isTablet
                ? 24
                : 16,
          ),
          child: Center(
            child: Container(
              width: cardWidth,
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
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
                  if (isPaid)
                    Container(
                      padding: EdgeInsets.all(successIconPad),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: successIconSize,
                        color: Colors.green,
                      ),
                    ),

                  if (!isPaid)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/qr.png",
                        height: qrSize,
                        width: qrSize,
                        fit: BoxFit.cover,
                      ),
                    ),

                  SizedBox(height: isTablet || isDesktop ? 28 : 24),
                  Text(
                    isPaid
                        ? "Payment Successful"
                        : "Pay ₹${widget.total.toStringAsFixed(2)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? Colors.green : Colors.black,
                    ),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 12 : 10),

                  Text(
                    isPaid
                        ? "Your order has been placed successfully"
                        : "Scan QR using any UPI app",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: subtitleFontSize,
                    ),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 36 : 30),

                  SizedBox(
                    width: double.infinity,
                    height: btnHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPaid ? Colors.green : Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed:
                          isLoading
                              ? null
                              : () async {
                                if (isPaid) {
                                  await saveOrderAndNavigate();
                                } else {
                                  setState(() => isPaid = true);
                                }
                              },
                      child:
                          isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                isPaid ? "Done" : "Pay Now",
                                style: TextStyle(
                                  fontSize: btnFontSize,
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
      ),
    );
  }
}
