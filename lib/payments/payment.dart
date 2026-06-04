import 'package:flutter/material.dart';
import 'package:foodapp/payments/card_payment.dart';
import 'package:foodapp/payments/cash_payment.dart';
import 'package:foodapp/payments/upi_payment.dart';
import 'package:foodapp/widgets/responsive.dart';

class PaymentPage extends StatelessWidget {
  final double total;

  const PaymentPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    // Horizontal padding
    final double hPad = isDesktop
        ? screenWidth * 0.18
        : isTablet
            ? screenWidth * 0.06
            : 16.0;

    // Top payment card padding
    final double cardPadding = isDesktop
        ? 28.0
        : isTablet
            ? 24.0
            : 20.0;

    // Total amount font size
    final double totalFontSize = isDesktop
        ? 44.0
        : isTablet
            ? 40.0
            : 36.0;

    final double totalLabelSize = isDesktop
        ? 16.0
        : isTablet
            ? 15.0
            : 14.0;

    // Section heading
    final double sectionTitleSize = isDesktop
        ? 24.0
        : isTablet
            ? 22.0
            : 20.0;

    // Payment method tile font
    final double tileTitleSize = isDesktop
        ? 19.0
        : isTablet
            ? 18.0
            : 17.0;

    final double tileSubtitleSize = isDesktop
        ? 14.0
        : isTablet
            ? 13.5
            : 13.0;

    // Tile icon size
    final double tileIconSize = isDesktop
        ? 32.0
        : isTablet
            ? 30.0
            : 28.0;

    // Tile icon container padding
    final double tileIconPad = isDesktop
        ? 16.0
        : isTablet
            ? 14.0
            : 12.0;

    // AppBar font
    final double appBarFontSize = isDesktop
        ? 22.0
        : isTablet
            ? 20.0
            : 18.0;

    // Payment method tiles data
    final List<({
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
    })> methods = [
      (
        title: 'UPI Payment',
        subtitle: 'Google Pay, PhonePe, Paytm',
        icon: Icons.account_balance_wallet,
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UpiPaymentPage(total: total)),
        ),
      ),
      (
        title: 'Card Payment',
        subtitle: 'Visa, MasterCard, RuPay',
        icon: Icons.credit_card,
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CardPaymentPage(total: total)),
        ),
      ),
      (
        title: 'Cash On Delivery',
        subtitle: 'Pay when order arrives',
        icon: Icons.delivery_dining,
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CashPaymentPage(total: total)),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Payments",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: appBarFontSize,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: ConstrainedBox(
            // Caps content width on very wide screens
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 860 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Total Payable Card ──────────────────────────────────
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: 16,
                  ),
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7A00), Color(0xFFFFA726)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TOTAL PAYABLE",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: totalLabelSize,
                        ),
                      ),
                      SizedBox(height: isTablet || isDesktop ? 12 : 10),
                      Text(
                        "₹${total.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: totalFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isTablet || isDesktop ? 22 : 18),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet || isDesktop ? 16 : 12,
                          vertical: isTablet || isDesktop ? 10 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: isTablet || isDesktop ? 20 : 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "100% Secure Payments",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet || isDesktop ? 15 : 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Section Title ───────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: Text(
                    "Choose Payment Method",
                    style: TextStyle(
                      fontSize: sectionTitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: isTablet || isDesktop ? 16 : 14),

                // ── Payment Method Tiles ────────────────────────────────
                ...methods.map(
                  (method) => GestureDetector(
                    onTap: method.onTap,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: hPad,
                        vertical: isTablet || isDesktop ? 10 : 8,
                      ),
                      padding: EdgeInsets.all(
                        isTablet || isDesktop ? 20 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon container
                          Container(
                            padding: EdgeInsets.all(tileIconPad),
                            decoration: BoxDecoration(
                              color: method.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              method.icon,
                              color: method.color,
                              size: tileIconSize,
                            ),
                          ),

                          SizedBox(width: isTablet || isDesktop ? 20 : 16),

                          // Title + subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method.title,
                                  style: TextStyle(
                                    fontSize: tileTitleSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  method.subtitle,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: tileSubtitleSize,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.arrow_forward_ios,
                            size: isTablet || isDesktop ? 18 : 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isTablet || isDesktop ? 24 : 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}