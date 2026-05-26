import 'package:flutter/material.dart';
import 'package:foodapp/admin/screens/admin_mainscreen.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> saveLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Enter email & password", Colors.red);
      return;
    }

    if (!isValidEmail(email)) {
      showMessage("Invalid email", Colors.red);
      return;
    }

    if (password.length < 4) {
      showMessage("Password too short", Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        showMessage("Login failed", Colors.red);
        return;
      }

      await saveLogin(email);

      final userData =
          await Supabase.instance.client
              .from('users')
              .select()
              .eq('id', user.id)
              .single();

      if (!mounted) return;

      if (userData['is_blocked'] == true) {
        await Supabase.instance.client.auth.signOut();
        showMessage("Your account has been blocked by admin!", Colors.red);
        setState(() => isLoading = false);
        return;
      }

      if (userData['is_admin'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminMainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      }
    } catch (e) {
      showMessage(e.toString(), Colors.red);
    } finally {
      setState(() => isLoading = false);
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
      backgroundColor: Color(0xFFF8F8F8),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood, color: Colors.orange, size: 60),
            SizedBox(height: 20),
            Text(
              "Welcome back!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Login to Continue',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 112, 111, 111),
              ),
            ),
            SizedBox(height: 10),
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
            TextField(
              controller: passwordController,
              obscureText: true,
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
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child:
                    isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Login", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignUpScreen()),
                );
              },
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
