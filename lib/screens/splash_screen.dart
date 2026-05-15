import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodapp/screens/login_screen.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:foodapp/widgets/admin.dart';


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
    await Future.delayed(Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? email = prefs.getString('email');

    print("IS LOGGED IN: $isLoggedIn");
    print("EMAIL: $email");

    if (!mounted) return;

    if (isLoggedIn && email == "rifanasherin80@gmail.com") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Admin()),
      );
    } else if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.fastfood, size: 60, color: Colors.white),
            ),
            SizedBox(height: 25),

            Text(
              "Yumzi",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),

            Text("Fresh Food, Faster 🍔", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
