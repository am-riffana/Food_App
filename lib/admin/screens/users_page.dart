import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodapp/widgets/responsive.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _supabase = Supabase.instance.client;

  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final data = await _supabase
        .from('users')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      users = data;
      isLoading = false;
    });
  }

  Future<void> toggleBlock(String id, bool currentStatus) async {
    await _supabase
        .from('users')
        .update({'is_blocked': !currentStatus})
        .eq('id', id);

    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.w(context);
    final height = Responsive.h(context);
    final isTablet = Responsive.isTablet(context);

    final activeUsers = users.where((e) => e['is_blocked'] != true).length;
    final blockedUsers = users.where((e) => e['is_blocked'] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Users Management",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22 : width * 0.05,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadUsers,
            icon: Icon(
              Icons.refresh,
              color: Colors.orange,
              size: isTablet ? 28 : width * 0.06,
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                /// DASHBOARD
                Container(
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: dashboardCard(
                          "Total",
                          users.length.toString(),
                          Icons.people,
                          Colors.orange,
                          width,
                          isTablet,
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Expanded(
                        child: dashboardCard(
                          "Active",
                          activeUsers.toString(),
                          Icons.check_circle,
                          Colors.green,
                          width,
                          isTablet,
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Expanded(
                        child: dashboardCard(
                          "Blocked",
                          blockedUsers.toString(),
                          Icons.block,
                          Colors.red,
                          width,
                          isTablet,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),

                /// LIST
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    itemCount: users.length,
                    itemBuilder: (_, i) {
                      final user = users[i];
                      final isBlocked = user['is_blocked'] ?? false;
                      final isAdmin = user['is_admin'] ?? false;

                      return Container(
                        margin: EdgeInsets.only(bottom: height * 0.015),
                        padding: EdgeInsets.all(width * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: isTablet ? 28 : width * 0.07,
                              backgroundColor:
                                  isBlocked ? Colors.red : Colors.orange,
                              child: Text(
                                (user['firstname'] ?? 'U')[0].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTablet ? 20 : width * 0.05,
                                ),
                              ),
                            ),

                            SizedBox(width: width * 0.04),

                            /// INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${user['firstname'] ?? ''} ${user['lastname'] ?? ''}",
                                          style: TextStyle(
                                            fontSize:
                                                isTablet ? 16 : width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (isAdmin)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.02,
                                            vertical: height * 0.004,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            "ADMIN",
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize:
                                                  isTablet ? 12 : width * 0.025,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  SizedBox(height: height * 0.008),

                                  Text(
                                    user['email'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: isTablet ? 13 : width * 0.03,
                                    ),
                                  ),

                                  SizedBox(height: height * 0.01),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.004,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isBlocked
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isBlocked ? "Blocked" : "Active",
                                      style: TextStyle(
                                        color: isBlocked
                                            ? Colors.red
                                            : Colors.green,
                                        fontSize: isTablet
                                            ? 12
                                            : width * 0.028,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// BUTTON
                            if (!isAdmin)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isBlocked
                                      ? Colors.green
                                      : Colors.red,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04,
                                    vertical: height * 0.012,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () =>
                                    toggleBlock(user['id'], isBlocked),
                                child: Text(
                                  isBlocked ? "Unblock" : "Block",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 13 : width * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  /// CARD
  Widget dashboardCard(
    String title,
    String count,
    IconData icon,
    Color color,
    double width,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: isTablet ? 20 : width * 0.05,
            child: Icon(icon,
                color: Colors.white,
                size: isTablet ? 20 : width * 0.05),
          ),
          SizedBox(height: width * 0.02),
          Text(
            count,
            style: TextStyle(
              fontSize: isTablet ? 22 : width * 0.055,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 13 : width * 0.03,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}