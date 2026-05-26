import 'package:flutter/material.dart';
import 'package:foodapp/auth/otpscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> sendOtp() async {
    String first = firstname.text.trim();
    String last = lastname.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (first.isEmpty) { showMessage("Enter First Name", Colors.red); return; }
    if (last.isEmpty) { showMessage("Enter Last Name", Colors.red); return; }
    if (email.isEmpty) { showMessage("Enter Email", Colors.red); return; }
    if (!email.contains("@") || !email.contains(".")) {
      showMessage("Enter Valid Email", Colors.red); return;
    }
    if (password.isEmpty) { showMessage("Enter Password", Colors.red); return; }
    if (password.length < 6) {
      showMessage("Password must be 6 characters", Colors.red); return;
    }

    setState(() => isLoading = true);

    try {
      // ✅ Check if email is blocked
      final existingUser = await Supabase.instance.client
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (existingUser != null) {
        // ✅ Check if blocked
        if (existingUser['is_blocked'] == true) {
          showMessage("This email has been blocked by admin!", Colors.red);
          setState(() => isLoading = false);
          return;
        }
        showMessage("Email already has an account", Colors.red);
        setState(() => isLoading = false);
        return;
      }

      await Supabase.instance.client.auth.signInWithOtp(email: email);

      showMessage("OTP Sent Successfully", Colors.green);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Otpscreen(
            firstname: first,
            lastname: last,
            email: email,
            password: password,
          ),
        ),
      );
    } catch (e) {
      showMessage(e.toString(), Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text("Sign Up",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Create an account to continue",
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 30),
            TextField(
              controller: firstname,
              decoration: InputDecoration(
                hintText: "First Name",
                filled: true,
                fillColor: const Color(0xfff7e6d3),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: lastname,
              decoration: InputDecoration(
                hintText: "Last Name",
                filled: true,
                fillColor: const Color(0xfff7e6d3),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                filled: true,
                fillColor: const Color(0xfff7e6d3),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                filled: true,
                fillColor: const Color(0xfff7e6d3),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://developers.google.com/identity/images/g-logo.png",
                      height: 24, width: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text("Continue with Google",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
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