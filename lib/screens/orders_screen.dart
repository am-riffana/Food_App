import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';
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
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double hPad =
        isDesktop
            ? screenWidth * 0.18
            : isTablet
            ? screenWidth * 0.06
            : 14.0;

    final double imgSize =
        isDesktop
            ? 110.0
            : isTablet
            ? 95.0
            : 80.0;

    final double itemNameSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 15.0;

    final double priceFontSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 18.0
            : 16.0;

    final double totalLabelSize =
        isDesktop
            ? 14.0
            : isTablet
            ? 13.0
            : 12.0;

    final double totalAmountSize =
        isDesktop
            ? 22.0
            : isTablet
            ? 20.0
            : 18.0;

    final double statusFontSize =
        isDesktop
            ? 15.0
            : isTablet
            ? 14.0
            : 13.0;

    final double badgeFontSize =
        isDesktop
            ? 12.0
            : isTablet
            ? 11.5
            : 11.0;

    final double cardRadius = isTablet || isDesktop ? 26.0 : 22.0;

    final double cardPadding = isTablet || isDesktop ? 18.0 : 14.0;

    final double cardMarginBottom = isTablet || isDesktop ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet || isDesktop ? 20 : 17,
          ),
        ),
        actions: [
          IconButton(
            onPressed: fetchOrders,
            icon: Icon(
              Icons.refresh,
              color: Colors.orange,
              size: isTablet || isDesktop ? 28 : 24,
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.orange))
              : RefreshIndicator(
                onRefresh: fetchOrders,
                color: Colors.orange,
                child:
                    orders.isEmpty
                        ? ListView(
                          children: [
                            SizedBox(
                              height: Responsive.h(context) * 0.7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: isTablet || isDesktop ? 120 : 90,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    height: isTablet || isDesktop ? 20 : 15,
                                  ),
                                  Text(
                                    "No Orders Yet",
                                    style: TextStyle(
                                      fontSize: isTablet || isDesktop ? 26 : 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Order something tasty 🍔",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: isTablet || isDesktop ? 16 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: hPad,
                            vertical: 14,
                          ),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            final status = order['status'] ?? 'pending';
                            final items = List<Map<String, dynamic>>.from(
                              order['items'] ?? [],
                            );
                            final firstItem =
                                items.isNotEmpty ? items[0] : null;

                            return Container(
                              margin: EdgeInsets.only(bottom: cardMarginBottom),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(cardRadius),
                                boxShadow: [
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: cardPadding,
                                      vertical: isTablet || isDesktop ? 14 : 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor(
                                        status,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(cardRadius),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          statusIcon(status),
                                          color: statusColor(status),
                                          size: isTablet || isDesktop ? 24 : 20,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            statusLabel(status),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: statusColor(status),
                                              fontSize: statusFontSize,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                isTablet || isDesktop ? 12 : 10,
                                            vertical:
                                                isTablet || isDesktop ? 6 : 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor(
                                              status,
                                            ).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            status.toUpperCase(),
                                            style: TextStyle(
                                              color: statusColor(status),
                                              fontWeight: FontWeight.bold,
                                              fontSize: badgeFontSize,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(cardPadding),
                                    child: Column(
                                      children: [
                                        ...items.map(
                                          (item) => Padding(
                                            padding: EdgeInsets.only(
                                              bottom:
                                                  isTablet || isDesktop
                                                      ? 14
                                                      : 10,
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  child: Image.network(
                                                    item['image'] ?? '',
                                                    height: imgSize,
                                                    width: imgSize,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (_, __, ___) =>
                                                            Container(
                                                              height: imgSize,
                                                              width: imgSize,
                                                              color:
                                                                  Colors
                                                                      .orange
                                                                      .shade100,
                                                              child: Icon(
                                                                Icons.fastfood,
                                                                color:
                                                                    Colors
                                                                        .orange,
                                                              ),
                                                            ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      isTablet || isDesktop
                                                          ? 18
                                                          : 14,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item['name'] ?? '',
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style: TextStyle(
                                                          fontSize:
                                                              itemNameSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  isTablet ||
                                                                          isDesktop
                                                                      ? 10
                                                                      : 8,
                                                              vertical: 3,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors
                                                                      .orange
                                                                      .shade50,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              "Qty ${item['qty']}",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    badgeFontSize,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            "₹${((item['price'] as num) * (item['qty'] as num)).toStringAsFixed(0)}",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  priceFontSize,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                        SizedBox(
                                          height: isTablet || isDesktop ? 6 : 4,
                                        ),
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
                                                    fontSize: totalLabelSize,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  "₹${(order['total_amount'] as num).toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                    fontSize: totalAmountSize,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (status != 'delivered' &&
                                                status != 'cancelled')
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isTablet || isDesktop
                                                            ? 20
                                                            : 14,
                                                    vertical:
                                                        isTablet || isDesktop
                                                            ? 12
                                                            : 10,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                onPressed:
                                                    firstItem == null
                                                        ? null
                                                        : () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => TrackOrderPage(
                                                                    itemName:
                                                                        firstItem['name'],
                                                                    image:
                                                                        firstItem['image'],
                                                                    orderedTime:
                                                                        order['created_at'] ??
                                                                        DateTime.now()
                                                                            .toIso8601String(),
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                icon: Icon(
                                                  Icons.delivery_dining,
                                                  color: Colors.white,
                                                  size:
                                                      isTablet || isDesktop
                                                          ? 22
                                                          : 18,
                                                ),
                                                label: Text(
                                                  "Track Order",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        isTablet || isDesktop
                                                            ? 15
                                                            : 13,
                                                  ),
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
