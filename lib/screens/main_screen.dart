import 'package:flutter/material.dart';
import 'package:foodapp/screens/home.dart';
import 'package:foodapp/screens/order.dart';
import 'package:foodapp/screens/payment.dart';
import 'package:foodapp/screens/profile.dart';
import 'package:foodapp/widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const OrdersPage(),
    const PaymentPage(), 
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 

      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; 
          });
        },
      ),
    );
  }
}