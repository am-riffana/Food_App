import 'package:flutter/material.dart';
import 'package:foodapp/admin/pages/add_food.dart';
import 'package:foodapp/admin/pages/add_orders.dart';
import 'package:foodapp/admin/pages/add_profile.dart';
import 'package:foodapp/admin/pages/dashboard.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() =>
      _AdminHomePageState();
}

class _AdminHomePageState
    extends State<AdminHomePage> {

  int currentIndex = 0;

  final pages = [
    const DashboardPage(),
    const AddFoodPage(),
    const AddOrders(),
    const AddProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,

        selectedItemColor:
            Colors.orange,

        unselectedItemColor:
            Colors.grey,

        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Add Food",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}