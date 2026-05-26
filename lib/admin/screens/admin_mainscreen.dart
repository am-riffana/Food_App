import 'package:flutter/material.dart';
import 'package:foodapp/admin/screens/banner_screen.dart';
import 'package:foodapp/admin/screens/coupen_screen.dart';
import 'package:foodapp/admin/screens/dashbaord_page.dart';
import 'package:foodapp/admin/screens/food_page.dart';
import 'package:foodapp/admin/screens/orders_page.dart';
import 'package:foodapp/admin/screens/users_page.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  final _pages = [
    DashboardPage(),
    FoodsPage(),
    BannersPage(),
    CouponsPage(),
    OrdersPage(),
    UsersPage(),
  ];

  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.dashboard_rounded, "label": "Dashboard"},
    {"icon": Icons.fastfood_rounded, "label": "Foods"},
    {"icon": Icons.image_rounded, "label": "Banners"},
    {"icon": Icons.local_offer_rounded, "label": "Coupons"},
    {"icon": Icons.receipt_long_rounded, "label": "Orders"},
    {"icon": Icons.people_alt_rounded, "label": "Users"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),

      body: SafeArea(child: _pages[_currentIndex]),

      bottomNavigationBar: Container(
        margin: EdgeInsets.all(14),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];

            final isSelected = _currentIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
              },

              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),

                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 16 : 0,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.orange.withOpacity(0.15)
                          : Colors.transparent,

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  children: [
                    Icon(
                      item['icon'],
                      color: isSelected ? Colors.orange : Colors.grey,
                      size: 26,
                    ),

                    if (isSelected)
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          item['label'],
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
