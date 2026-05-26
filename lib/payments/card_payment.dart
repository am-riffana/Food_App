import 'package:flutter/material.dart';
import 'package:foodapp/payments/order_helper.dart';
import 'package:foodapp/screens/orders_screen.dart';

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
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Card Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (!isPaid)
              Container(
                width: double.infinity,
                height: 210,
                padding: EdgeInsets.all(22),
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
                        Icon(Icons.credit_card, color: Colors.white, size: 34),
                        Icon(Icons.wifi, color: Colors.white),
                      ],
                    ),
                    Spacer(),
                    Text(
                      cardController.text.isEmpty
                          ? "**** **** **** 4589"
                          : cardController.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
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
                                fontSize: 12,
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
                                fontSize: 12,
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
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, size: 90, color: Colors.green),
              ),

            SizedBox(height: 24),

            if (isPaid)
              Column(
                children: [
                  Text(
                    "Payment Successful",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your order has been placed successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),

            if (!isPaid)
              Container(
                margin: EdgeInsets.only(top: 24),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: cardController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Card Number",
                        prefixIcon: Icon(Icons.credit_card),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: expiryController,
                            decoration: InputDecoration(
                              hintText: "MM/YY",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: cvvController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "CVV",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Card Holder Name",
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 28),

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
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          if (isPaid) {
                            setState(() => isLoading = true);
                            try {
                              await saveOrderToSupabase(paymentMethod: 'Card');
                            } catch (e) {
                              debugPrint('Order save failed: $e');
                            }
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => OrdersPage()),
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
    );
  }
}
