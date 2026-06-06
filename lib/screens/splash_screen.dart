import 'package:flutter/material.dart';
import 'package:foodapp/screens/login_screen.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    await Future.delayed( Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn
            ?  MainScreen()
            :  LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final isTablet = width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child: ConstrainedBox(
          constraints:  BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 40 : width * 0.08,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                                Container(
                  padding: EdgeInsets.all(isTablet ? 28 : width * 0.06),
                  decoration:  BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fastfood,
                    size: isTablet ? 60 : width * 0.15,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: height * 0.03),

                Text(
                  "Yumzi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 42 : width * 0.08,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                SizedBox(height: height * 0.01),
                Text(
                  "Fresh Food, Faster 🍔",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isTablet ? 18 : width * 0.04,
                  ),
                ),

                SizedBox(height: height * 0.04),
                 CircularProgressIndicator(
                  color: Colors.orange,
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}