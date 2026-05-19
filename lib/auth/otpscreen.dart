import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class Otpscreen extends StatefulWidget {
  final String email;

  const Otpscreen({
    super.key,
    required this.email,
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
      secondsRemaining = 30;
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
  Future<void> sendOtp() async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: widget.email,
      );

      startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent to email")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
Future<void> verifyOtp() async {
  final otp = pinController.text.trim();

  if (otp.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enter OTP")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    final response =
        await Supabase.instance.client.auth.verifyOTP(
      email: widget.email,
      token: otp,
      type: OtpType.email,
    );

    final user = response.user;

    if (user != null) {
      await Supabase.instance.client.from('users').insert({
        'id': user.id,
        'email': user.email,
      });
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    setState(() => isLoading = false);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("OTP Verification"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("OTP sent to ${widget.email}"),
             SizedBox(height: 30),
            Pinput(
              length: 6,
              controller: pinController,
            ),
             SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:  EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ?  CircularProgressIndicator(color: Colors.white)
                    :  Text("Verify OTP"),
              ),
            ),
             SizedBox(height: 20),
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