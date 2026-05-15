import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodapp/screens/home.dart';

class Otpscreen extends StatefulWidget {
  final String email;
  final String password;
  final String phonenumber;

  const Otpscreen({
    super.key,
    required this.email,
    required this.password,
    required this.phonenumber,
  });

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {

  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    sendOtp(); // ✅ Send OTP Automatically
  }

  // 📲 SEND OTP USING SUPABASE
  Future<void> sendOtp() async {
    try {

      await supabase.auth.signInWithOtp(
        phone: '+91${widget.phonenumber}',
      );

      showMessage("OTP Sent Successfully");

    } catch (e) {
      showMessage("Failed to send OTP");
      print(e);
    }
  }

  // 🔐 VERIFY OTP
  Future<void> verifyOtp() async {

    try {

      final response = await supabase.auth.verifyOTP(
        phone: '+91${widget.phonenumber}',
        token: pinController.text.trim(),
        type: OtpType.sms,
      );

      if (response.user != null) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );

      } else {
        showMessage("Invalid OTP");
      }

    } catch (e) {
      showMessage("OTP Verification Failed");
      print(e);
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);
    const fillColor = Color(0xfff7e6d3);

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(

      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: Colors.orange,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "OTP sent to +91 ${widget.phonenumber}",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              Pinput(
                length: 6,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,

                onCompleted: (pin) {},

                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(
                      color: focusedBorderColor,
                    ),
                  ),
                ),

                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    border: Border.all(
                      color: focusedBorderColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(

                  onPressed: verifyOtp,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),

                  child: const Text(
                    "Verify OTP",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}