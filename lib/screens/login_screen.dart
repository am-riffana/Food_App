import 'package:flutter/material.dart';
import 'package:foodapp/admin/screens/admin_mainscreen.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:foodapp/widgets/responsive.dart';
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

      final userData = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      if (userData != null && userData['is_blocked'] == true) {
        await Supabase.instance.client.auth.signOut();
        showMessage("Your account has been blocked by admin!", Colors.red);
        setState(() => isLoading = false);
        return;
      }

      // ── Check is_admin from DB first, then fallback to email + password ─
      final bool isAdmin =
          (userData != null && userData['is_admin'] == true) ||
              (email == 'admin123@gmail.com' &&
                  password == '123456'); // ← replace these

      if (isAdmin) {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double formWidth = isDesktop
        ? 460.0
        : isTablet
            ? 420.0
            : double.infinity;

    final double hPad = isDesktop
        ? 40.0
        : isTablet
            ? 32.0
            : 20.0;

    final double titleSize = isDesktop
        ? 32.0
        : isTablet
            ? 28.0
            : 26.0;

    final double subtitleSize = isDesktop
        ? 15.0
        : isTablet
            ? 13.0
            : 12.0;

    final double iconSize = isDesktop
        ? 80.0
        : isTablet
            ? 70.0
            : 60.0;

    final double btnVertPad = isDesktop
        ? 18.0
        : isTablet
            ? 16.0
            : 14.0;

    final double fieldFontSize = isDesktop
        ? 16.0
        : isTablet
            ? 15.0
            : 14.0;

    Widget formCard = Container(
      width: formWidth,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 36),
      decoration: (isTablet || isDesktop)
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fastfood, color: Colors.orange, size: iconSize),
          SizedBox(height: isTablet || isDesktop ? 24 : 20),

          Text(
            "Welcome back!",
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isTablet || isDesktop ? 10 : 8),

          Text(
            'Login to Continue',
            style: TextStyle(
              fontSize: subtitleSize,
              color: const Color.fromARGB(255, 112, 111, 111),
            ),
          ),
          SizedBox(height: isTablet || isDesktop ? 28 : 20),

          // Email field
          TextField(
            controller: emailController,
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: const Icon(Icons.email),
              filled: true,
              fillColor: const Color(0xfff7e6d3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: isTablet || isDesktop ? 18 : 14,
                horizontal: 16,
              ),
            ),
          ),
          SizedBox(height: isTablet || isDesktop ? 18 : 15),

          // Password field
          TextField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: const Icon(Icons.lock),
              filled: true,
              fillColor: const Color(0xfff7e6d3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: isTablet || isDesktop ? 18 : 14,
                horizontal: 16,
              ),
            ),
          ),
          SizedBox(height: isTablet || isDesktop ? 28 : 20),

          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: btnVertPad),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fieldFontSize + 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(height: isTablet || isDesktop ? 16 : 12),

          // Sign up link
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignUpScreen()),
              );
            },
            child: Text(
              "Don't have an account? Sign Up",
              style: TextStyle(fontSize: subtitleSize + 1),
            ),
          ),
        ],
      ),
    );

    // ── Mobile ────────────────────────────────────────────────────────
    if (!isTablet && !isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: Padding(
          padding: EdgeInsets.all(hPad),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [formCard],
          ),
        ),
      );
    }

    // ── Tablet & Desktop ──────────────────────────────────────────────
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE0B2),
              Color(0xFFF8F8F8),
              Color(0xFFFFE0B2),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? screenWidth * 0.25 : 40,
              vertical: 40,
            ),
            child: formCard,
          ),
        ),
      ),
    );
  }
}