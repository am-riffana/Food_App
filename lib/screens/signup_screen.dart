import 'package:flutter/material.dart';
import 'package:foodapp/auth/otpscreen.dart';
import 'package:foodapp/widgets/responsive.dart';
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
    final first = firstname.text.trim();
    final last = lastname.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (first.isEmpty ||
        last.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      showMessage("Fill all fields", Colors.red);
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      showMessage("Enter valid email", Colors.red);
      return;
    }

    if (password.length < 6) {
      showMessage("Password must be 6+ characters", Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      final existingUser =
          await supabase
              .from('users')
              .select()
              .eq('email', email)
              .maybeSingle();

      if (existingUser != null) {
        if (existingUser['is_blocked'] == true) {
          showMessage("You are blocked by admin", Colors.red);
          setState(() => isLoading = false);
          return;
        }

        showMessage("Email already exists", Colors.red);
        setState(() => isLoading = false);
        return;
      }

      await supabase.auth.signInWithOtp(email: email);

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

      showMessage("OTP sent successfully", Colors.green);
    } catch (e) {
      showMessage(e.toString(), Colors.red);
    }

    setState(() => isLoading = false);
  }

  void showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isTablet = width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 40 : width * 0.06,
                vertical: 20,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: height * 0.02),

                  Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 34 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Sign up to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  _buildField(firstname, "First Name"),
                  SizedBox(height: height * 0.02),

                  _buildField(lastname, "Last Name"),
                  SizedBox(height: height * 0.02),

                  _buildField(emailController, "Email"),
                  SizedBox(height: height * 0.02),

                  _buildField(passwordController, "Password", obscure: true),

                  SizedBox(height: height * 0.04),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              "https://developers.google.com/identity/images/g-logo.png",
                              height: 18,
                              width: 18,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Continue with Google",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xfff7e6d3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}