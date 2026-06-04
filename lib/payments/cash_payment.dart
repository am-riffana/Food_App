import 'package:flutter/material.dart';
import 'package:foodapp/payments/order_helper.dart';
import 'package:foodapp/screens/orders_screen.dart';
import 'package:foodapp/widgets/responsive.dart';

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
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);

    // Card max width
    final double cardWidth = isDesktop
        ? 480.0
        : isTablet
            ? 440.0
            : double.infinity;

    // Card padding
    final double cardPadding = isDesktop
        ? 36.0
        : isTablet
            ? 28.0
            : 24.0;

    // Icon circle size & padding
    final double iconSize = isDesktop
        ? 100.0
        : isTablet
            ? 90.0
            : 80.0;

    final double iconPad = isDesktop
        ? 28.0
        : isTablet
            ? 24.0
            : 20.0;

    // Font sizes
    final double titleSize = isDesktop
        ? 32.0
        : isTablet
            ? 30.0
            : 28.0;

    final double subtitleSize = isDesktop
        ? 18.0
        : isTablet
            ? 17.0
            : 16.0;

    final double infoTextSize = isDesktop
        ? 16.0
        : isTablet
            ? 15.5
            : 15.0;

    final double btnFontSize = isDesktop
        ? 20.0
        : isTablet
            ? 19.0
            : 18.0;

    // Button height
    final double btnHeight = isDesktop
        ? 64.0
        : isTablet
            ? 62.0
            : 58.0;

    // AppBar font
    final double appBarFontSize = isDesktop
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
          "Cash On Delivery",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: appBarFontSize,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : isTablet ? 24 : 16),
          child: Center(
            child: Container(
              width: cardWidth,
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
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
                  // ── Icon ─────────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(iconPad),
                    decoration: BoxDecoration(
                      color: isConfirmed
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isConfirmed
                          ? Icons.check_circle
                          : Icons.delivery_dining,
                      size: iconSize,
                      color: isConfirmed ? Colors.green : Colors.orange,
                    ),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 28 : 24),

                  // ── Title ─────────────────────────────────────────────
                  Text(
                    isConfirmed
                        ? "Order Confirmed"
                        : "Pay ₹${widget.total.toStringAsFixed(2)} on Delivery",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: isConfirmed ? Colors.green : Colors.black,
                    ),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 16 : 14),

                  // ── Subtitle ──────────────────────────────────────────
                  Text(
                    isConfirmed
                        ? "Your order has been placed successfully"
                        : "Please keep exact change ready for faster delivery.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: subtitleSize,
                    ),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 36 : 30),

                  // ── Info Banner ───────────────────────────────────────
                  if (!isConfirmed)
                    Container(
                      padding: EdgeInsets.all(isTablet || isDesktop ? 20 : 18),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.orange,
                            size: isTablet || isDesktop ? 26 : 22,
                          ),
                          SizedBox(width: isTablet || isDesktop ? 14 : 12),
                          Expanded(
                            child: Text(
                              "Cash payment will be collected by the delivery partner.",
                              style: TextStyle(fontSize: infoTextSize),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: isTablet || isDesktop ? 36 : 30),

                  // ── Action Button ─────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: btnHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isConfirmed ? Colors.green : Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: isLoading
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
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : Text(
                              isConfirmed ? "Done" : "Confirm Order",
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