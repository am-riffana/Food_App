import 'package:flutter/material.dart';
import 'package:foodapp/screens/card_payment.dart';
import 'package:foodapp/screens/cash_payment.dart';
import 'package:foodapp/screens/upi_payment.dart';

class PaymentPage extends StatefulWidget {
  final double total;

  const PaymentPage({super.key, required this.total});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  void navigate(BuildContext context, String method) {
    if (method == "Card") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CardPayment(total: widget.total),
        ),
      );
    }

    if (method == "UPI") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UpiPayment(total: widget.total),
        ),
      );
    }

    if (method == "Cash") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CodPayment(total: widget.total),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title:  Text("Checkout"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Column(
        children: [
           SizedBox(height: 20),
          Container(
            margin:  EdgeInsets.all(16),
            padding:  EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow:  [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "₹${widget.total.toStringAsFixed(2)}",
                  style:  TextStyle(
                    fontSize: 22,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
           SizedBox(height: 10),
          GestureDetector(
            onTap: () => navigate(context, "Card"),
            child: Container(
              margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow:  [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child:  Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.orange),
                  SizedBox(width: 12),
                  Text("Card Payment", style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigate(context, "UPI"),
            child: Container(
              margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow:  [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child:  Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.orange),
                  SizedBox(width: 12),
                  Text("UPI Payment", style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigate(context, "Cash"),
            child: Container(
              margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow:  [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child:  Row(
                children: [
                  Icon(Icons.delivery_dining, color: Colors.orange),
                  SizedBox(width: 12),
                  Text("Cash on Delivery", style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}