import 'package:flutter/material.dart';
import 'package:foodapp/auth/otpscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final firstname=TextEditingController();
  final lastname=TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController(); 
  
  bool isLoading = false;

  Future<void> sendOtp() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage("Enter Email", const Color.fromARGB(255, 110, 30, 25));
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.signInWithOtp(email: email);

      showMessage("OTP Sent Successfully", Colors.green);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Otpscreen(email: email)),
      );
    } catch (e) {
      showMessage(e.toString(), const Color.fromARGB(255, 152, 38, 30));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void showMessage(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(title: Text("Sign Up"), backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Text('Create an account to continue',style: TextStyle(fontSize: 12,color: Colors.grey),),
            SizedBox(height: 15),
            TextField(
              controller: firstname,
              decoration: InputDecoration(
                hintText: "FirstName",
                filled: true,
                fillColor: const Color(0xfff7e6d3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
             SizedBox(height: 20),
            TextField(
              controller: lastname,
              decoration: InputDecoration(
                hintText: "LastName",
                filled: true,
                fillColor: const Color(0xfff7e6d3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: " Email",
                filled: true,
                fillColor: const Color(0xfff7e6d3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: " Password",
                filled: true,
                fillColor: const Color(0xfff7e6d3),
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
                onPressed: isLoading ? null : sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        " Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        "https://developers.google.com/identity/images/g-logo.png",
                        height: 24,
                        width: 24,
                      ),
                       SizedBox(width: 10),
                       Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
