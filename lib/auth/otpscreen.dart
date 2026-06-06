import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:foodapp/widgets/responsive.dart';
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
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (secondsRemaining == 0) {
        setState(() => canResend = true);
        t.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  Future<void> sendOtp() async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(email: widget.email);
      startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP Sent Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> verifyOtp() async {
    final otp = pinController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter OTP"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.email,
      );

      final user = response.user;

      if (user != null) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(
            data: {
              'name': "${widget.firstname} ${widget.lastname}",
              'first_name': widget.firstname,
              'last_name': widget.lastname,
            },
          ),
        );

        await Supabase.instance.client.from('users').upsert({
          'id': user.id,
          'firstname': widget.firstname,
          'lastname': widget.lastname,
          'email': widget.email,
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signup Successful"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final double contentWidth =
        isDesktop
            ? 460.0
            : isTablet
            ? 420.0
            : double.infinity;

    final double outerPad =
        isDesktop
            ? 40.0
            : isTablet
            ? 32.0
            : 20.0;

    final double iconSize =
        isDesktop
            ? 100.0
            : isTablet
            ? 90.0
            : 80.0;

    final double emailTextSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;

    final double btnFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;

    final double resendFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 15.0
            : 14.0;

    final double btnVertPad =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;

    final double pinBoxSize =
        isDesktop
            ? 58.0
            : isTablet
            ? 54.0
            : 48.0;

    final double appBarFontSize =
        isDesktop
            ? 22.0
            : isTablet
            ? 20.0
            : 18.0;

    final defaultPinTheme = PinTheme(
      width: pinBoxSize,
      height: pinBoxSize,
      textStyle: TextStyle(
        fontSize:
            isDesktop
                ? 22
                : isTablet
                ? 20
                : 18,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange.shade50,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange.shade100,
      ),
    );

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(isTablet || isDesktop ? 24 : 18),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.email, size: iconSize, color: Colors.orange),
        ),

        SizedBox(height: isTablet || isDesktop ? 28 : 20),

        Text(
          "OTP sent to\n${widget.email}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: emailTextSize,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: isTablet || isDesktop ? 48 : 40),

        Pinput(
          length: 6,
          controller: pinController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
        ),

        SizedBox(height: isTablet || isDesktop ? 36 : 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: btnVertPad),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                      "Verify OTP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: btnFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),

        SizedBox(height: isTablet || isDesktop ? 24 : 20),

        TextButton(
          onPressed: canResend ? sendOtp : null,
          child: Text(
            canResend ? "Resend OTP" : "Resend OTP in $secondsRemaining sec",
            style: TextStyle(
              color: canResend ? Colors.orange : Colors.grey,
              fontSize: resendFontSize,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OTP Verification",
          style: TextStyle(fontSize: appBarFontSize),
        ),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFF8F8F8),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(outerPad),
          child: Center(
            child:
                (isTablet || isDesktop)
                    ? Container(
                      width: contentWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 40 : 32,
                        vertical: isDesktop ? 48 : 40,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: content,
                    )
                    : content,
          ),
        ),
      ),
    );
  }
}
