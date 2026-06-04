import 'package:flutter/material.dart';
import 'package:foodapp/admin/models/order_model.dart';
import 'package:foodapp/admin/services/order_service.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _service = OrderService();
  final _supabase = Supabase.instance.client;
  List<OrderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    setState(() => isLoading = true);
    final data = await _service.getOrders();
    setState(() {
      orders = data;
      isLoading = false;
    });
  }

  // ── Send order status notification ───────────────────────────────────
  Future<void> sendOrderNotification(
      String userId, String status) async {
    final messages = {
      'confirmed': (
        'Order Confirmed ✅',
        'Your order has been confirmed!',
        'order_confirmed'
      ),
      'preparing': (
        'Preparing Your Food 👨‍🍳',
        'Chef is preparing your order.',
        'order_preparing'
      ),
      'delivered': (
        'Order Delivered 🎉',
        'Your order has been delivered. Enjoy your meal!',
        'order_delivered'
      ),
      'cancelled': (
        'Order Cancelled ❌',
        'Your order has been cancelled.',
        'order_cancelled'
      ),
    };

    final msg = messages[status];
    if (msg == null) return;

    try {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'title': msg.$1,
        'body': msg.$2,
        'type': msg.$3,
      });
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_top;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant;
      case 'delivered':
        return Icons.delivery_dining;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_long;
    }
  }

  int getCrossAxisCount(BuildContext context) {
    if (Responsive.isDesktop(context)) return 3;
    if (Responsive.isTablet(context)) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final int crossAxis = getCrossAxisCount(context);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text(
          'Manage Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet || isDesktop ? 22 : 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: loadOrders,
            icon: Icon(
              Icons.refresh,
              color: Colors.orange,
              size: isTablet || isDesktop ? 28 : 24,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: isTablet || isDesktop ? 100 : 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No orders yet",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isTablet || isDesktop ? 20 : 16,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadOrders,
                  color: Colors.orange,
                  child: Padding(
                    padding: EdgeInsets.all(
                        isTablet || isDesktop ? 16 : 12),
                    child: crossAxis == 1
                        ? ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (_, i) =>
                                _orderCard(orders[i], isTablet, isDesktop),
                          )
                        : GridView.builder(
                            itemCount: orders.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxis,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio:
                                  isDesktop ? 2.2 : 1.9,
                            ),
                            itemBuilder: (_, i) =>
                                _orderCard(orders[i], isTablet, isDesktop),
                          ),
                  ),
                ),
    );
  }

  Widget _orderCard(
      OrderModel order, bool isTablet, bool isDesktop) {
    final color = statusColor(order.status);
    final icon = statusIcon(order.status);

    return Container(
      margin: EdgeInsets.only(
          bottom: isTablet || isDesktop ? 0 : 12),
      padding: EdgeInsets.all(isTablet || isDesktop ? 16 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8).toUpperCase()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet || isDesktop ? 16 : 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.createdAt.substring(0, 10),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: isTablet || isDesktop ? 13 : 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${order.totalAmount}',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet || isDesktop ? 17 : 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // ── Status dropdown ───────────────────────────────────────────
          Row(
            children: [
              Text(
                "Status:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet || isDesktop ? 14 : 13,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: order.status,
                    underline: const SizedBox(),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: color),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet || isDesktop ? 14 : 13,
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'pending', child: Text('Pending')),
                      DropdownMenuItem(
                          value: 'confirmed', child: Text('Confirmed')),
                      DropdownMenuItem(
                          value: 'preparing', child: Text('Preparing')),
                      DropdownMenuItem(
                          value: 'delivered', child: Text('Delivered')),
                      DropdownMenuItem(
                          value: 'cancelled', child: Text('Cancelled')),
                    ],
                    onChanged: (val) async {
                      if (val != null && val != order.status) {
                        await _service.updateOrderStatus(
                          id: order.id,
                          status: val,
                        );
                        // ── Send notification to user ─────────────────
                        await sendOrderNotification(
                            order.userId, val);
                        loadOrders();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}