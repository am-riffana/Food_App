import 'package:flutter/material.dart';
import 'package:foodapp/admin/screens/banner_screen.dart';
import 'package:foodapp/admin/screens/categories_page.dart';
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
    AdminCategoriesViewPage(),  
    BannersPage(),
    CouponsPage(),
    OrdersPage(),
    UsersPage(),
  ];

  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.dashboard_rounded, "label": "Dashboard"},
    {"icon": Icons.fastfood_rounded, "label": "Foods"},
    {"icon": Icons.category_rounded, "label": "Categories"},
    {"icon": Icons.image_rounded, "label": "Banners"},
    {"icon": Icons.local_offer_rounded, "label": "Coupons"},
    {"icon": Icons.receipt_long_rounded, "label": "Orders"},
    {"icon": Icons.people_alt_rounded, "label": "Users"},
  ];

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tablet = isTablet(context);
    final desktop = isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(width * 0.03),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: width * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset:  Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isSelected = _currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: AnimatedContainer(
                  duration:  Duration(milliseconds: 250),
                  padding:
                      EdgeInsets.symmetric(vertical: width * 0.02),
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.005),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orange.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'],
                        color: isSelected
                            ? Colors.orange
                            : Colors.grey,
                        size: tablet ? 26 : 22,
                      ),
                       SizedBox(height: 3),
                      Text(
                        item['label'],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.orange
                              : Colors.grey,
                          fontSize: tablet ? 11 : 9,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
} 