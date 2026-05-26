import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage> {
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
      final users =
          await _supabase.from('users').select('id');

      final foods =
          await _supabase.from('foods').select('id');

      final orders = await _supabase
          .from('orders')
          .select();

      double revenue = 0;

      for (var o in orders) {
        revenue +=
            (o['total_amount'] as num?)?.toDouble() ??
                0;
      }

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

  Widget analyticsCircle({
    required String title,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    if (value > 100) {
      value = 100;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),

              const SizedBox(width: 8),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    centerSpaceRadius: 48,

                    sections: [
                      PieChartSectionData(
                        value: value,
                        color: color,
                        radius: 20,
                        showTitle: false,
                      ),

                      PieChartSectionData(
                        value: 100 - value,
                        color: Colors.grey.shade200,
                        radius: 20,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      "${value.toInt()}%",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                        color: color,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f5f7),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Column(
                  children: [
                    /// TOP CARD
                    Container(
                      padding:
                          const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Colors.orange,
                            Color(0xffff9800),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                                32),
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  "Yumzi Admin",
                                  style: TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize: 28,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 8),

                                const Text(
                                  "Restaurant Analytics Dashboard",
                                  style: TextStyle(
                                    color: Colors
                                        .white70,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(
                                    height: 24),

                                Text(
                                  "₹${totalRevenue.toStringAsFixed(2)}",
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize: 34,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 6),

                                const Text(
                                  "Total Revenue",
                                  style: TextStyle(
                                    color: Colors
                                        .white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.storefront,
                            color: Colors.white,
                            size: 90,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// CIRCLE ANALYTICS
                    Row(
                      children: [
                        Expanded(
                          child: analyticsCircle(
                            title: "Users",
                            value:
                                totalUsers == 0
                                    ? 0
                                    : (totalUsers /
                                            100) *
                                        100,
                            color: Colors.blue,
                            icon: Icons.people,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: analyticsCircle(
                            title: "Foods",
                            value:
                                totalFoods == 0
                                    ? 0
                                    : (totalFoods /
                                            100) *
                                        100,
                            color: Colors.orange,
                            icon: Icons.fastfood,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: analyticsCircle(
                            title: "Orders",
                            value:
                                totalOrders == 0
                                    ? 0
                                    : (totalOrders /
                                            100) *
                                        100,
                            color: Colors.green,
                            icon: Icons
                                .receipt_long,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: analyticsCircle(
                            title: "Revenue",
                            value:
                                totalRevenue == 0
                                    ? 0
                                    : (totalRevenue /
                                            10000) *
                                        100,
                            color: Colors.purple,
                            icon: Icons
                                .currency_rupee,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}