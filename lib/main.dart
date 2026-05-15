import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:foodapp/screens/splash_screen.dart';

void main() async {
  // 1. Ensure binding first
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Error handling wrapper
  try {
    // Firebase
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    print("Firebase Initialized");

    // Hive
    await Hive.initFlutter();
    await Hive.openBox('orderspage');
    await Hive.openBox('paymentpage');
    print("Hive Initialized");

    // Supabase
    await Supabase.initialize(
      url: 'https://cgclfpzqgrqlbfhdkefn.supabase.co',
      anonKey: 'sb_publishable_LNKlnWLWOp_FbXsvdJw19A_RwEvOVjZ',
    );
    print("Supabase Initialized");

  } catch (e, stackTrace) {
    // THIS WILL PRINT THE REAL REASON FOR WHITE SCREEN IN YOUR CONSOLE
    print("INIT ERROR: $e");
    print(stackTrace);
    
    // Show error on screen so you don't just see white
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text("Init Error: $e")))));
    return;
  }

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
    );
  }
}
