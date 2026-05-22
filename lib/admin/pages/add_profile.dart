import 'package:flutter/material.dart';

class AddProfile extends StatelessWidget {
  const AddProfile({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor:
            Colors.orange,

        title: const Text(
          "Admin Profile",
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            const CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage(
                "https://randomuser.me/api/portraits/men/32.jpg",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Admin",
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "Logout",
              ),
            ),
          ],
        ),
      ),
    );
  }
}