import 'package:flutter/material.dart';
import 'package:foodapp/widgets/track_order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final data = await _supabase
          .from('orders')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        orders = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Fetch orders error: $e');
      setState(() => isLoading = false);
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
        return Icons.info_outline;
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Order Pending';
      case 'confirmed':
        return 'Order Confirmed';
      case 'preparing':
        return 'Preparing your food...';
      case 'delivered':
        return 'Delivered ✓';
      case 'cancelled':
        return 'Order Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          "Your Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: fetchOrders,
            icon:  Icon(Icons.refresh, color: Colors.orange),
          ),
        ],
      ),
      body: isLoading
          ?  Center(
              child: CircularProgressIndicator(color: Colors.orange),
            )
          : RefreshIndicator(
              onRefresh: fetchOrders,
              color: Colors.orange,
              child: orders.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 90,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 15),
                              Text(
                                "No Orders Yet",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Order something tasty 🍔",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding:  EdgeInsets.all(14),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final status = order['status'] ?? 'pending';
                        final items = List<Map<String, dynamic>>.from(
                            order['items'] ?? []);
                        final firstItem =
                            items.isNotEmpty ? items[0] : null;

                        return Container(
                          margin:  EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow:  [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor(status).withOpacity(0.1),
                                  borderRadius:  BorderRadius.vertical(
                                    top: Radius.circular(22),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      statusIcon(status),
                                      color: statusColor(status),
                                    ),
                                     SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        statusLabel(status),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: statusColor(status),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor(status)
                                            .withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        status.toUpperCase(),
                                        style: TextStyle(
                                          color: statusColor(status),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.all(14),
                                child: Column(
                                  children: [
                                    ...items.map(
                                      (item) => Padding(
                                        padding:
                                             EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            // IMAGE
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.network(
                                                item['image'] ?? '',
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                  height: 80,
                                                  width: 80,
                                                  color:
                                                      Colors.orange.shade100,
                                                  child:  Icon(
                                                    Icons.fastfood,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ),
                                            ),
                                             SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['name'] ?? '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:  TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                   SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:  EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .orange.shade50,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          "Qty ${item['qty']}",
                                                          style:
                                                               TextStyle(
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                       SizedBox(width: 8),
                                                      Text(
                                                        "₹${((item['price'] as num) * (item['qty'] as num)).toStringAsFixed(0)}",
                                                        style:  TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                     Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                             Text(
                                              "Total Paid",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "₹${(order['total_amount'] as num).toStringAsFixed(0)}",
                                              style:  TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (status != 'delivered' &&
                                            status != 'cancelled')
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: firstItem == null
                                                ? null
                                                : () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            TrackOrderPage(
                                                          itemName:
                                                              firstItem['name'],
                                                          image: firstItem[
                                                              'image'],
                                                          orderedTime: order[
                                                                  'created_at'] ??
                                                              DateTime.now()
                                                                  .toIso8601String(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            icon:  Icon(
                                              Icons.delivery_dining,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            label:  Text(
                                              "Track Order",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                      },
                    ),
            ),
    );
  }
}