import 'package:flutter/material.dart';
import 'package:foodapp/payments/payment.dart';
import 'package:foodapp/screens/cart_screen.dart';
import 'package:foodapp/screens/categories_screen.dart';
import 'package:foodapp/screens/home_screen.dart';
import 'package:foodapp/screens/orders_screen.dart';
import 'package:foodapp/widgets/bottom_nav.dart';
import 'package:foodapp/widgets/responsive.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);

    if (isTablet || isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: Colors.white,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme:
                   IconThemeData(color: Colors.orange),
              selectedLabelTextStyle:  TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
              unselectedIconTheme:
                  IconThemeData(color: Colors.grey.shade400),
              unselectedLabelTextStyle:
                  TextStyle(color: Colors.grey.shade500),
              indicatorColor: Colors.orange.withOpacity(0.12),
              destinations:  [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view),
                  label: Text('Categories'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_cart_outlined),
                  selectedIcon: Icon(Icons.shopping_cart),
                  label: Text('Cart'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: Text('Orders'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.payment_outlined),
                  selectedIcon: Icon(Icons.payment),
                  label: Text('Payment'),
                ),
              ],
            ),
            Container(width: 1, color: Colors.grey.shade200),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}