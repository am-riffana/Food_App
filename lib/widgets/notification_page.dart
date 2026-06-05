import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    try {
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        setState(() {
          isLoading = false;
          errorMsg = 'Please log in to view notifications';
        });
        return;
      }

      final data = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        notifications = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMsg = e.toString();
      });
    }
  }

  Future<void> markAllRead() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    await _supabase
        .from('notifications')
        .update({'is_read': true}).eq('user_id', userId);
    fetchNotifications();
  }

  Future<void> markOneRead(String id) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true}).eq('id', id);
    setState(() {
      final index = notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) notifications[index]['is_read'] = true;
    });
  }

  Future<void> deleteNotification(String id) async {
    await _supabase.from('notifications').delete().eq('id', id);
    setState(() => notifications.removeWhere((n) => n['id'] == id));
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'order_confirmed':
        return Icons.check_circle;
      case 'order_preparing':
        return Icons.restaurant;
      case 'order_delivered':
        return Icons.delivery_dining;
      case 'order_cancelled':
        return Icons.cancel;
      case 'offer':
        return Icons.local_offer;
      case 'new_item':
        return Icons.fastfood;
      default:
        return Icons.notifications;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case 'order_confirmed':
        return Colors.green;
      case 'order_preparing':
        return Colors.purple;
      case 'order_delivered':
        return Colors.blue;
      case 'order_cancelled':
        return Colors.red;
      case 'offer':
        return Colors.orange;
      case 'new_item':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String timeAgo(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double hPad = isDesktop
        ? screenWidth * 0.15
        : isTablet
            ? screenWidth * 0.05
            : 16.0;

    final int unreadCount =
        notifications.where((n) => n['is_read'] == false).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: isTablet || isDesktop ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              "Notifications",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: isTablet || isDesktop ? 22 : 18,
              ),
            ),
            if (unreadCount > 0)
              Text(
                "$unreadCount unread",
                style:  TextStyle(
                  color: Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllRead,
              child: const Text(
                "All read",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          IconButton(
            onPressed: fetchNotifications,
            icon: Icon(
              Icons.refresh,
              color: Colors.orange,
              size: isTablet || isDesktop ? 26 : 22,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange))

          : errorMsg != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          errorMsg!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: fetchNotifications,
                          icon: const Icon(Icons.refresh,
                              color: Colors.white),
                          label: const Text(
                            "Retry",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )

          // ── Empty state ─────────────────────────────────────────────
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: isTablet || isDesktop ? 100 : 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No notifications yet",
                        style: TextStyle(
                          fontSize: isTablet || isDesktop ? 20 : 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You'll see order updates here",
                        style: TextStyle(
                          fontSize: isTablet || isDesktop ? 14 : 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                )

          // ── Notification list ───────────────────────────────────────
          : RefreshIndicator(
              onRefresh: fetchNotifications,
              color: Colors.orange,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: hPad,
                  vertical: 16,
                ),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  final bool isRead = item['is_read'] == true;
                  final String type = item['type'] ?? 'general';
                  final color = getColor(type);
                  final icon = getIcon(type);

                  return Dismissible(
                    key: Key(item['id']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => deleteNotification(item['id']),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.delete,
                          color: Colors.white),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (!isRead) markOneRead(item['id']);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(
                          bottom: isTablet || isDesktop ? 14 : 10,
                        ),
                        padding: EdgeInsets.all(
                          isTablet || isDesktop ? 18 : 14,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isRead ? Colors.white : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: isRead
                              ? null
                              : Border.all(
                                  color: Colors.orange.shade200,
                                  width: 1,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              padding: EdgeInsets.all(
                                isTablet || isDesktop ? 14 : 11,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(icon,
                                  color: color,
                                  size:
                                      isTablet || isDesktop ? 28 : 24),
                            ),

                            SizedBox(
                                width: isTablet || isDesktop ? 16 : 12),

                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] ?? '',
                                          style: TextStyle(
                                            fontSize: isTablet || isDesktop
                                                ? 16
                                                : 14,
                                            fontWeight: isRead
                                                ? FontWeight.w500
                                                : FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (!isRead)
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['body'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize:
                                          isTablet || isDesktop ? 14 : 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    timeAgo(item['created_at']),
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize:
                                          isTablet || isDesktop ? 12 : 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}