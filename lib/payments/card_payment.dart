import 'package:flutter/material.dart';
import 'package:foodapp/payments/order_helper.dart';
import 'package:foodapp/screens/orders_screen.dart';
import 'package:foodapp/widgets/responsive.dart';

class CardPaymentPage extends StatefulWidget {
  final double total;

  const CardPaymentPage({super.key, required this.total});

  @override
  State<CardPaymentPage> createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  bool isPaid = false;
  bool isLoading = false;

  final TextEditingController cardController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double contentWidth =
        isDesktop
            ? 520.0
            : isTablet
            ? 480.0
            : double.infinity;

    final double outerPad =
        isDesktop
            ? 32.0
            : isTablet
            ? 24.0
            : 16.0;

    final double cardHeight =
        isDesktop
            ? 240.0
            : isTablet
            ? 224.0
            : 210.0;

    final double cardPad =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 22.0;

    final double cardNumberSize =
        isDesktop
            ? 28.0
            : isTablet
            ? 26.0
            : 24.0;

    final double cardIconSize =
        isDesktop
            ? 40.0
            : isTablet
            ? 37.0
            : 34.0;

    final double successIconSize =
        isDesktop
            ? 110.0
            : isTablet
            ? 100.0
            : 90.0;

    final double successIconPad =
        isDesktop
            ? 28.0
            : isTablet
            ? 25.0
            : 22.0;

    final double successTitleSize =
        isDesktop
            ? 34.0
            : isTablet
            ? 32.0
            : 30.0;

    final double successSubtitleSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;

    final double formPad =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 20.0;

    final double fieldFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 15.0
            : 14.0;

    final double btnHeight =
        isDesktop
            ? 64.0
            : isTablet
            ? 62.0
            : 58.0;

    final double btnFontSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 19.0
            : 18.0;

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
          "Card Payment",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: appBarFontSize,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(outerPad),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Column(
              children: [
                if (!isPaid)
                  Container(
                    width: double.infinity,
                    height: cardHeight,
                    padding: EdgeInsets.all(cardPad),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF7A00), Color(0xFFFFA726)],
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.credit_card,
                              color: Colors.white,
                              size: cardIconSize,
                            ),
                            Icon(
                              Icons.wifi,
                              color: Colors.white,
                              size: isTablet || isDesktop ? 26 : 22,
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          cardController.text.isEmpty
                              ? "**** **** **** 4589"
                              : cardController.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: cardNumberSize,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isTablet || isDesktop ? 20 : 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CARD HOLDER",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isTablet || isDesktop ? 13 : 12,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  nameController.text.isEmpty
                                      ? "YOUR NAME"
                                      : nameController.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isTablet || isDesktop ? 15 : 14,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "EXPIRES",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isTablet || isDesktop ? 13 : 12,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  expiryController.text.isEmpty
                                      ? "08/28"
                                      : expiryController.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isTablet || isDesktop ? 15 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

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

                SizedBox(height: isTablet || isDesktop ? 28 : 24),

                if (isPaid)
                  Column(
                    children: [
                      Text(
                        "Payment Successful",
                        style: TextStyle(
                          fontSize: successTitleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: isTablet || isDesktop ? 12 : 10),
                      Text(
                        "Your order has been placed successfully",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: successSubtitleSize,
                        ),
                      ),
                    ],
                  ),

                if (!isPaid)
                  Container(
                    margin: EdgeInsets.only(
                      top: isTablet || isDesktop ? 28 : 24,
                    ),
                    padding: EdgeInsets.all(formPad),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: cardController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: fieldFontSize),
                          decoration: InputDecoration(
                            hintText: "Card Number",
                            prefixIcon: Icon(Icons.credit_card),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: isTablet || isDesktop ? 18 : 14,
                              horizontal: 16,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),

                        SizedBox(height: isTablet || isDesktop ? 20 : 18),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: expiryController,
                                style: TextStyle(fontSize: fieldFontSize),
                                decoration: InputDecoration(
                                  hintText: "MM/YY",
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: isTablet || isDesktop ? 18 : 14,
                                    horizontal: 16,
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            SizedBox(width: isTablet || isDesktop ? 16 : 14),
                            Expanded(
                              child: TextField(
                                controller: cvvController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: fieldFontSize),
                                decoration: InputDecoration(
                                  hintText: "CVV",
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: isTablet || isDesktop ? 18 : 14,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: isTablet || isDesktop ? 20 : 18),

                        // Card holder name
                        TextField(
                          controller: nameController,
                          style: TextStyle(fontSize: fieldFontSize),
                          decoration: InputDecoration(
                            hintText: "Card Holder Name",
                            prefixIcon: Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: isTablet || isDesktop ? 18 : 14,
                              horizontal: 16,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: isTablet || isDesktop ? 32 : 28),

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
                                setState(() => isLoading = true);
                                try {
                                  await saveOrderToSupabase(
                                    paymentMethod: 'Card',
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
                                setState(() => isPaid = true);
                              }
                            },
                    child:
                        isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              isPaid
                                  ? "Done"
                                  : "Pay ₹${widget.total.toStringAsFixed(2)}",
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
    );
  }
}
