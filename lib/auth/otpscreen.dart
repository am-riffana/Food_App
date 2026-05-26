import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Otpscreen extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String email;
  final String password;

  const Otpscreen({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  final pinController = TextEditingController();

  Timer? timer;

  int secondsRemaining = 60;
  bool canResend = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();

    setState(() {
      secondsRemaining = 60;
      canResend = false;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining == 0) {
        setState(() {
          canResend = true;
        });
        t.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  // RESEND OTP
  Future<void> sendOtp() async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: widget.email,
      );

      startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Sent Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // VERIFY OTP
  Future<void> verifyOtp() async {
    final otp = pinController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter OTP"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.email,
      );

      final user = response.user;

      if (user != null) {
        // 1. SAVE AUTH METADATA (for profile page name)
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(
            data: {
              'name':
                  "${widget.firstname} ${widget.lastname}",
              'first_name': widget.firstname,
              'last_name': widget.lastname,
            },
          ),
        );

        // 2. SAVE TO USERS TABLE (database)
        await Supabase.instance.client.from('users').upsert({
          'id': user.id,
          'firstname': widget.firstname,
          'lastname': widget.lastname,
          'email': widget.email,
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signup Successful"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email,
              size: 80,
              color: Colors.orange,
            ),

            const SizedBox(height: 20),

            Text(
              "OTP sent to\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 40),

            // OTP INPUT
            Pinput(
              length: 6,
              controller: pinController,
            ),

            const SizedBox(height: 30),

            // VERIFY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Verify OTP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // RESEND OTP
            TextButton(
              onPressed: canResend ? sendOtp : null,
              child: Text(
                canResend
                    ? "Resend OTP"
                    : "Resend OTP in $secondsRemaining sec",
                style: TextStyle(
                  color: canResend ? Colors.orange : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}