import 'package:flutter/material.dart';
import 'package:foodapp/screens/home.dart';
import 'package:foodapp/widgets/admin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Please enter email & password"),backgroundColor: Colors.orange,),
      );
      return;
    }

    if (email == "rifanasherin80@gmail.com" && password == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  Admin()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  HomePage()),
      );
    }
  }

  void signUp() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Please fill all fields"),backgroundColor: Colors.orange),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Account created successfully 🎉")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.all(20),
          child: Column(
            children: [
               SizedBox(height: 40),
               Icon(
                Icons.fastfood,
                color: Color.fromARGB(255, 240, 155, 26),
                size: 60,
              ),

               SizedBox(height: 20),

               Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

               SizedBox(height: 5),
              Text(
                isLogin ? "Login to continue" : "Create your account",
                style:  TextStyle(color: const Color.fromARGB(255, 160, 148, 148)),
              ),

               SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isLogin = true),
                      child: Container(
                        padding:  EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isLogin ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: isLogin ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isLogin = false),
                      child: Container(
                        padding:  EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: !isLogin ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: !isLogin ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

               SizedBox(height: 25),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon:  Icon(Icons.email),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 247, 230, 211),
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
                  prefixIcon:  Icon(Icons.lock),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 247, 230, 211),
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
                  onPressed: () {
                    if (isLogin) {
                      login();   
                    } else {
                      signUp();  
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 254, 253),
                    padding:  EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLogin ? "Login" : "Sign Up",
                    style:  TextStyle(fontSize: 16),
                  ),
                ),
              ),

               SizedBox(height: 20),

              Text(
                isLogin
                    ? "Don’t have an account? Sign Up"
                    : "Already have an account? Login",
                style:  TextStyle(color: const Color.fromARGB(255, 124, 122, 122)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}