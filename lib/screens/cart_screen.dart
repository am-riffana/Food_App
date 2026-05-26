import 'package:flutter/material.dart';
import 'package:foodapp/payments/payment.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
    const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box ordersBox;
  final couponController = TextEditingController();
  double discountAmount = 0;
  String couponMessage = '';
  bool couponApplied = false;
  bool isCheckingCoupon = false;
  Map? appliedCoupon;

  @override
  void initState() {
    super.initState();
    ordersBox = Hive.box('orders');
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  double get totalPrice {
    double total = 0;
    for (var item in ordersBox.values) {
      total += (item['price'] * item['qty']);
    }
    return total;
  }

  double get finalTotal {
    return (totalPrice + 60 - discountAmount).clamp(0, double.infinity);
  }

  Future<void> applyCoupon() async {
    final code = couponController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() {
        couponMessage = 'Enter a coupon code';
        couponApplied = false;
      });
      return;
    }

    setState(() => isCheckingCoupon = true);

    try {
      final data = await Supabase.instance.client
          .from('coupons')
          .select()
          .eq('code', code)
          .eq('is_active', true)
          .maybeSingle();

      if (data == null) {
        setState(() {
          couponMessage = 'Invalid or expired coupon';
          couponApplied = false;
          discountAmount = 0;
          appliedCoupon = null;
        });
        return;
      }

     if (data['expiry_date'] != null) {
        final expiry = DateTime.parse(data['expiry_date']);
        if (DateTime.now().isAfter(expiry)) {
          setState(() {
            couponMessage = 'Coupon has expired';
            couponApplied = false;
            discountAmount = 0;
            appliedCoupon = null;
          });
          return;
        }
      }

      final minOrder = (data['min_order_amount'] as num).toDouble();
      if (totalPrice < minOrder) {
        setState(() {
          couponMessage =
              'Minimum order ₹${minOrder.toStringAsFixed(0)} required';
          couponApplied = false;
          discountAmount = 0;
          appliedCoupon = null;
        });
        return;
      }

      double discount = 0;
      if (data['discount_type'] == 'percentage') {
        discount = totalPrice * (data['discount_value'] as num) / 100;
        if (data['max_discount'] != null) {
          final maxDiscount = (data['max_discount'] as num).toDouble();
          discount = discount.clamp(0, maxDiscount);
        }
      } else {
        discount = (data['discount_value'] as num).toDouble();
      }

      setState(() {
        discountAmount = discount;
        couponApplied = true;
        appliedCoupon = data;
        couponMessage =
            'Coupon applied! You saved ₹${discount.toStringAsFixed(0)}';
      });
    } catch (e) {
      setState(() {
        couponMessage = 'Error applying coupon';
        couponApplied = false;
      });
    } finally {
      setState(() => isCheckingCoupon = false);
    }
  }

  void removeCoupon() {
    setState(() {
      couponController.clear();
      discountAmount = 0;
      couponMessage = '';
      couponApplied = false;
      appliedCoupon = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) =>  MainScreen()),
          ),
          icon:  Icon(Icons.arrow_back, color: Colors.white),
        ),
        title:  Text(
          "My Cart",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ordersBox.clear();
              removeCoupon();
              setState(() {});
            },
            child:  Text("Clear",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ordersBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:  EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(Icons.shopping_cart,
                        size: 70, color: Colors.orange),
                  ),
                   SizedBox(height: 20),
                   Text("Add delicious food 🍔",
                      style: TextStyle(color: Colors.grey, fontSize: 15)),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:  EdgeInsets.all(16),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final item = box.getAt(index);
                    return Container(
                      margin:  EdgeInsets.only(bottom: 16),
                      padding:  EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow:  [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              item["image"] ?? "",
                              height: 110,
                              width: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 110,
                                width: 110,
                                color: Colors.orange.shade100,
                                child:  Icon(Icons.fastfood,
                                    color: Colors.orange, size: 40),
                              ),
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  height: 110,
                                  width: 110,
                                  alignment: Alignment.center,
                                  child:  CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                           SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? "Food Item",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:  TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                 SizedBox(height: 6),
                                 Text("Fast Delivery",
                                    style: TextStyle(color: Colors.grey)),
                                 SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("₹${item['price']}",
                                        style:  TextStyle(
                                            color: Colors.orange,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                     Spacer(),
                                    // QTY
                                    Container(
                                      padding:  EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.orange),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (item['qty'] > 1) {
                                                item['qty']--;
                                                box.putAt(index, item);
                                                setState(() {});
                                              }
                                            },
                                            child:  Icon(Icons.remove,
                                                size: 18),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets
                                                .symmetric(horizontal: 12),
                                            child: Text(
                                              item['qty'].toString(),
                                              style:  TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              item['qty']++;
                                              box.putAt(index, item);
                                              setState(() {});
                                            },
                                            child:  Icon(Icons.add,
                                                size: 18,
                                                color: Colors.orange),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () {
                                    box.deleteAt(index);
                                    setState(() {});
                                  },
                                  child:  Row(
                                    children: [
                                      Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      SizedBox(width: 5),
                                      Text("Remove",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
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
              Container(
                padding:  EdgeInsets.all(20),
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    if (!couponApplied)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: couponController,
                              textCapitalization:
                                  TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: "Enter coupon code",
                                prefixIcon:  Icon(
                                    Icons.local_offer_outlined,
                                    color: Colors.orange),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:  EdgeInsets.symmetric(
                                    vertical: 12),
                              ),
                            ),
                          ),
                           SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding:  EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed:
                                isCheckingCoupon ? null : applyCoupon,
                            child: isCheckingCoupon
                                ?  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                :  Text("Apply",
                                    style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),

                    if (couponApplied)
                      Container(
                        padding:  EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                             Icon(Icons.check_circle,
                                color: Colors.green),
                             SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                couponMessage,
                                style:  TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: removeCoupon,
                              child:  Icon(Icons.close,
                                  color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),

                    if (couponMessage.isNotEmpty && !couponApplied)
                      Padding(
                        padding:  EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                             Icon(Icons.error_outline,
                                color: Colors.red, size: 16),
                             SizedBox(width: 6),
                            Text(couponMessage,
                                style:  TextStyle(
                                    color: Colors.red, fontSize: 13)),
                          ],
                        ),
                      ),

                     SizedBox(height: 16),
                    billRow("Item Total",
                        "₹${totalPrice.toStringAsFixed(0)}"),
                     SizedBox(height: 12),
                    billRow("Delivery Fee", "₹40"),
                     SizedBox(height: 12),
                    billRow("Taxes & Charges", "₹20"),

                    if (discountAmount > 0) ...[
                       SizedBox(height: 12),
                      billRow(
                        "Coupon Discount",
                        "- ₹${discountAmount.toStringAsFixed(0)}",
                        isDiscount: true,
                      ),
                    ],

                     Divider(height: 30),
                    billRow(
                      "To Pay",
                      "₹${finalTotal.toStringAsFixed(0)}",
                      isBold: true,
                    ),
                     SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentPage(total: finalTotal),
                            ),
                          );
                        },
                        child: Text(
                          "Proceed to Pay • ₹${finalTotal.toStringAsFixed(0)}",
                          style:  TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget billRow(String title, String value,
      {bool isBold = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight:
                    isBold ? FontWeight.bold : FontWeight.w500)),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight:
                    isBold ? FontWeight.bold : FontWeight.w700,
                color: isDiscount ? Colors.green : null)),
      ],
    );
  }
}