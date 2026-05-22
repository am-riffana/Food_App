import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget dashboardCard({
    required String title,
    required String value,
    required IconData icon,
  }) {

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: Colors.orange,
            size: 35,
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
        ),

        backgroundColor:
            Colors.orange,
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,

          children: [

            dashboardCard(
              title: "Total Orders",
              value: "120",
              icon: Icons.shopping_cart,
            ),

            dashboardCard(
              title: "Revenue",
              value: "₹45K",
              icon: Icons.currency_rupee,
            ),

            dashboardCard(
              title: "Foods",
              value: "35",
              icon: Icons.fastfood,
            ),

            dashboardCard(
              title: "Users",
              value: "89",
              icon: Icons.people,
            ),
          ],
        ),
      ),
    );
  }
}