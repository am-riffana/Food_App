import 'package:flutter/material.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context); // logout
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

             SizedBox(height: 20),

            // ➕ Add Food Button
            ElevatedButton(
              onPressed: () {
                // later → navigate to add food screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child:  Text("Add Food Item"),
            ),

             SizedBox(height: 20),

            // 📋 Food List (placeholder)
             Expanded(
              child: Center(
                child: Text(
                  "Food items will appear here 🍔",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}