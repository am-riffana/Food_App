import 'package:flutter/material.dart';
import 'package:foodapp/admin/models/order_model.dart';
import 'package:foodapp/admin/services/order_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _service = OrderService();
  List<OrderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final data = await _service.getOrders();
    setState(() { orders = data; isLoading = false; });
  }

  Color statusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Orders'), backgroundColor: Colors.orange),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final order = orders[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('Order #${order.id.substring(0, 8)}'),
                    subtitle: Text('₹${order.totalAmount} • ${order.createdAt.substring(0, 10)}'),
                    trailing: DropdownButton<String>(
                      value: order.status,
                      items: ['pending', 'confirmed', 'delivered', 'cancelled']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) async {
                        if (val != null) {
                          await _service.updateOrderStatus(order.id, val);
                          loadOrders();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}