import 'package:flutter/material.dart';
import 'package:foodapp/screens/cart.dart';
import 'package:foodapp/screens/categories.dart';
import 'package:foodapp/screens/home.dart';
import 'package:foodapp/screens/order.dart';
import 'package:foodapp/payments/payment.dart';
import 'package:foodapp/widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
     HomePage(),
     CategoriesPage(),
     CartPage(),
     OrdersPage(),
     PaymentPage(total: 0),
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

