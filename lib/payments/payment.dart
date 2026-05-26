import 'package:flutter/material.dart';
import 'package:foodapp/payments/card_payment.dart';
import 'package:foodapp/payments/cash_payment.dart';
import 'package:foodapp/payments/upi_payment.dart';

class PaymentPage extends StatelessWidget {
  final double total;

  const PaymentPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        centerTitle: true,

        title: Text(
          "Payments",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// TOP PAYMENT CARD
            Container(
              margin: EdgeInsets.all(16),

              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF7A00), Color(0xFFFFA726)],
                ),

                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "TOTAL PAYABLE",

                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "₹${total.toStringAsFixed(2)}",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 18),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                    decoration: BoxDecoration(
                      color: Colors.white24,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(Icons.lock, color: Colors.white, size: 18),

                        SizedBox(width: 8),

                        Text(
                          "100% Secure Payments",

                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Choose Payment Method",

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 14),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpiPaymentPage(total: total),
                  ),
                );
              },

              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                padding: EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),

                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Icon(
                        Icons.account_balance_wallet,

                        color: Colors.green,
                        size: 28,
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "UPI Payment",

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Google Pay, PhonePe, Paytm",

                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            /// CARD PAYMENT
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CardPaymentPage(total: total),
                  ),
                );
              },

              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                padding: EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),

                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Icon(
                        Icons.credit_card,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Card Payment",

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Visa, MasterCard, RuPay",

                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            /// CASH PAYMENT
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CashPaymentPage(total: total),
                  ),
                );
              },

              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                padding: EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),

                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Icon(
                        Icons.delivery_dining,

                        color: Colors.orange,
                        size: 28,
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Cash On Delivery",

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Pay when order arrives",

                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
