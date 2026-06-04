import 'package:flutter/material.dart';
import 'package:foodapp/admin/models/food_model.dart';
import 'package:foodapp/admin/models/order_model.dart';
import 'package:foodapp/admin/services/food_service.dart';
import 'package:foodapp/admin/services/order_service.dart';
import 'package:foodapp/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  await Hive.initFlutter();

  Hive.registerAdapter(FoodModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());

  await Hive.openBox('users');
  await Hive.openBox<FoodModel>('foods');
  await Hive.openBox('orders'); 
  await Hive.openBox('cart');
  await Hive.openBox('payment');

  await FoodService.init();
  await OrderService.init();

  await Supabase.initialize(
    url: 'https://cgclfpzqgrqlbfhdkefn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnY2xmcHpxZ3JxbGJmaGRrZWZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4MDg5ODgsImV4cCI6MjA5NDM4NDk4OH0.m7qLqh2xhDOLzy6leIXO2ms9EK1fM8XeHnDotPwVcTo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}