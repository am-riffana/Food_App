import 'package:flutter/material.dart';
import 'package:foodapp/screens/login_screen.dart';
import 'package:hive/hive.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void logout(BuildContext context) {
    // optional: clear user/session/orders if needed
    Hive.box('orders').clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),

            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Food Lover 🍔",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Text("user@email.com", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            _buildTile(Icons.shopping_bag, "My Orders", () {}),
            _buildTile(Icons.favorite, "Favorites", () {}),
            _buildTile(Icons.settings, "Settings", () {}),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text("Logout", style: TextStyle(color: Colors.white)),

                  onPressed: () => logout(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
