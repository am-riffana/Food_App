import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _supabase = Supabase.instance.client;

  int totalUsers = 0;
  int totalFoods = 0;
  int totalOrders = 0;
  double totalRevenue = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final users = await _supabase.from('users').select('id');
      final foods = await _supabase.from('foods').select('id');
      final orders = await _supabase.from('orders').select();

      double revenue = 0;
      for (var o in orders) {
        revenue += (o['total_amount'] as num?)?.toDouble() ?? 0;
      }

      if (!mounted) return;

      setState(() {
        totalUsers = (users as List).length;
        totalFoods = (foods as List).length;
        totalOrders = (orders as List).length;
        totalRevenue = revenue;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title:  Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content:  Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child:  Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _supabase.auth.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  double toPercent(num value, num max) {
    if (max == 0) return 0;
    return (value / max) * 100;
  }

  Widget analyticsCircle({
    required String title,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    final percentValue = value.clamp(0, 100).toDouble();

    return Container(
      padding:  EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color),
               SizedBox(width: 8),
              Text(
                title,
                style:  TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
           SizedBox(height: 15),
          SizedBox(
            height: 120,
            width: 120,
            child: PieChart(
              PieChartData(
                startDegreeOffset: -90,
                centerSpaceRadius: 40,
                sectionsSpace: 0,
                sections: [
                  PieChartSectionData(
                    value: percentValue,
                    color: color,
                    radius: 18,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 100 - percentValue,
                    color: Colors.grey.shade200,
                    radius: 18,
                    showTitle: false,
                  ),
                ],
              ),
            ),
          ),
           SizedBox(height: 10),
          Text(
            "${percentValue.toInt()}%",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff4f5f7),
      body: isLoading
          ?  Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 0.06),
                      decoration: BoxDecoration(
                        gradient:  LinearGradient(
                          colors: [Colors.orange, Color(0xffff9800)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                     Text(
                                      "Yumzi Admin",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                     SizedBox(height: 10),
                                    Text(
                                      "₹${totalRevenue.toStringAsFixed(2)}",
                                      style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                     SizedBox(height: 4),
                                     Text(
                                      "Total Revenue",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                               Icon(
                                Icons.storefront,
                                color: Colors.white,
                                size: 60,
                              ),
                            ],
                          ),

                           SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side:  BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding:  EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: logout,
                              icon:  Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              label:  Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                     SizedBox(height: 20),
                    Row(
                      children: [
                        _statCard(
                          "Users",
                          totalUsers.toString(),
                          Icons.people,
                          Colors.blue,
                        ),
                         SizedBox(width: 12),
                        _statCard(
                          "Foods",
                          totalFoods.toString(),
                          Icons.fastfood,
                          Colors.orange,
                        ),
                         SizedBox(width: 12),
                        _statCard(
                          "Orders",
                          totalOrders.toString(),
                          Icons.receipt_long,
                          Colors.green,
                        ),
                      ],
                    ),

                     SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        analyticsCircle(
                          title: "Users",
                          value: toPercent(totalUsers, 100),
                          color: Colors.blue,
                          icon: Icons.people,
                        ),
                        analyticsCircle(
                          title: "Foods",
                          value: toPercent(totalFoods, 100),
                          color: Colors.orange,
                          icon: Icons.fastfood,
                        ),
                        analyticsCircle(
                          title: "Orders",
                          value: toPercent(totalOrders, 100),
                          color: Colors.green,
                          icon: Icons.receipt_long,
                        ),
                        analyticsCircle(
                          title: "Revenue",
                          value: toPercent(totalRevenue, 10000),
                          color: Colors.purple,
                          icon: Icons.currency_rupee,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
  Widget _statCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
             SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
             SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}