import 'package:flutter/material.dart';
import 'package:foodapp/auth/otpscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController(); // ✅ NEW

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone); // ✅ simple validation
  }

  void goToOtp() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim(); // ✅ NEW

    if (email.isEmpty || password.isEmpty || phone.isEmpty) {
      showMessage("Please fill all fields", Colors.orange);
      return;
    }

    if (!isValidEmail(email)) {
      showMessage("Enter valid email", Colors.red);
      return;
    }

    if (!isValidPhone(phone)) {
      showMessage("Enter valid 10-digit phone number", Colors.red);
      return;
    }

    if (password.length < 4) {
      showMessage("Password must be at least 4 characters", Colors.red);
      return;
    }

    // 👉 Navigate to OTP screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Otpscreen(
          email: email,
          password: password,
          phonenumber: phone, // ✅ PASS THIS
        ),
      ),
    );
  }

  void showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Colors.orange,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            SizedBox(height: 20),

            Text(
              "Create Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // 📧 EMAIL
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Color(0xfff7e6d3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 15),

            // 📱 PHONE NUMBER (NEW)
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
                filled: true,
                fillColor: Color(0xfff7e6d3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 15),

            // 🔒 PASSWORD
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                filled: true,
                fillColor: Color(0xfff7e6d3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: goToOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}