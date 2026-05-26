import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final activeUsers =
        users.where((e) => e['is_blocked'] != true).length;

    final blockedUsers =
        users.where((e) => e['is_blocked'] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title:  Text(
          "Users Management",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadUsers,
            icon:  Icon(Icons.refresh, color: Colors.orange),
          ),
        ],
      ),

      body: isLoading
          ?  Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : Column(
              children: [
                Container(
                  padding:  EdgeInsets.all(18),
                  decoration:  BoxDecoration(
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
                          "Total Users",
                          users.length.toString(),
                          Icons.people,
                          Colors.orange,
                        ),
                      ),
                       SizedBox(width: 12),
                      Expanded(
                        child: dashboardCard(
                          "Active",
                          activeUsers.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                       SizedBox(width: 12),
                      Expanded(
                        child: dashboardCard(
                          "Blocked",
                          blockedUsers.toString(),
                          Icons.block,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    padding:  EdgeInsets.symmetric(horizontal: 14),
                    itemCount: users.length,
                    itemBuilder: (_, i) {
                      final user = users[i];
                      final isBlocked =
                          user['is_blocked'] ?? false;
                      final isAdmin =
                          user['is_admin'] ?? false;
                      return Container(
                        margin:  EdgeInsets.only(bottom: 14),
                        padding:  EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset:  Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: isBlocked
                                  ? Colors.red
                                  : Colors.orange,
                              child: Text(
                                (user['firstname'] ?? 'U')[0]
                                    .toUpperCase(),
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                             SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${user['firstname'] ?? ''} ${user['lastname'] ?? ''}",
                                          style:  TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (isAdmin)
                                        Container(
                                          padding:
                                               EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    20),
                                          ),
                                          child:  Text(
                                            "ADMIN",
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                   SizedBox(height: 6),
                                  Text(
                                    user['email'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                   SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                             EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isBlocked
                                              ? Colors.red
                                                  .withOpacity(0.1)
                                              : Colors.green
                                                  .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                        ),
                                        child: Text(
                                          isBlocked
                                              ? "Blocked"
                                              : "Active",
                                          style: TextStyle(
                                            color: isBlocked
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                             SizedBox(width: 10),
                            if (!isAdmin)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isBlocked
                                      ? Colors.green
                                      : Colors.red,
                                  elevation: 0,
                                  padding:
                                       EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () => toggleBlock(
                                  user['id'],
                                  isBlocked,
                                ),
                                child: Text(
                                  isBlocked
                                      ? "Unblock"
                                      : "Block",
                                  style:  TextStyle(
                                    color: Colors.white,
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
  Widget dashboardCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
           SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
           SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}