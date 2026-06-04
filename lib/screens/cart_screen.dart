import 'package:flutter/material.dart';
import 'package:foodapp/payments/payment.dart';
import 'package:foodapp/screens/main_screen.dart';
import 'package:foodapp/widgets/responsive.dart';
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
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        setState(() {
          couponMessage = 'Please log in to apply coupons';
          couponApplied = false;
          isCheckingCoupon = false;
        });
        return;
      }

      final usageCheck = await Supabase.instance.client
          .from('coupon_usage')
          .select()
          .eq('coupon_code', code)
          .eq('user_id', userId)
          .maybeSingle();

      if (usageCheck != null) {
        setState(() {
          couponMessage = 'You have already used this coupon';
          couponApplied = false;
          discountAmount = 0;
          appliedCoupon = null;
        });
        return;
      }

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

  Future<void> recordCouponUsage() async {
    if (!couponApplied || appliedCoupon == null) return;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await Supabase.instance.client.from('coupon_usage').insert({
        'coupon_code': appliedCoupon!['code'],
        'user_id': userId,
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    // Horizontal padding for list & bottom panel
    final double hPad = isDesktop
        ? screenWidth * 0.18
        : isTablet
            ? screenWidth * 0.06
            : 16.0;

    // Cart item image size
    final double imgSize = isDesktop
        ? 130.0
        : isTablet
            ? 120.0
            : 110.0;

    // Font sizes
    final double itemNameSize = isDesktop
        ? 20.0
        : isTablet
            ? 19.0
            : 18.0;

    final double itemPriceSize = isDesktop
        ? 22.0
        : isTablet
            ? 21.0
            : 20.0;

    final double billFontSize = isDesktop
        ? 17.0
        : isTablet
            ? 16.5
            : 16.0;

    final double payBtnHeight = isDesktop
        ? 64.0
        : isTablet
            ? 60.0
            : 56.0;

    final double payBtnFontSize = isDesktop
        ? 19.0
        : isTablet
            ? 18.0
            : 17.0;

    final double appBarFontSize = isDesktop
        ? 24.0
        : isTablet
            ? 23.0
            : 22.0;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
          ),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "My Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: appBarFontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ordersBox.clear();
              removeCoupon();
              setState(() {});
            },
            child: Text(
              "Clear",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isTablet || isDesktop ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ordersBox.listenable(),
        builder: (context, Box box, _) {
          // ── Empty State ───────────────────────────────────────────────
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet || isDesktop ? 32 : 24),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      size: isTablet || isDesktop ? 90 : 70,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: isTablet || isDesktop ? 24 : 20),
                  Text(
                    "Add delicious food 🍔",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isTablet || isDesktop ? 18 : 15,
                    ),
                  ),
                ],
              ),
            );
          }

          // ── Cart Content ──────────────────────────────────────────────
          return Column(
            children: [
              // Cart items list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: 16,
                  ),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final item = box.getAt(index);
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: isTablet || isDesktop ? 20 : 16,
                      ),
                      padding: EdgeInsets.all(isTablet || isDesktop ? 16 : 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              item["image"] ?? "",
                              height: imgSize,
                              width: imgSize,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: imgSize,
                                width: imgSize,
                                color: Colors.orange.shade100,
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.orange,
                                  size: 40,
                                ),
                              ),
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  height: imgSize,
                                  width: imgSize,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),

                          SizedBox(width: isTablet || isDesktop ? 18 : 14),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? "Food Item",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: itemNameSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                    height: isTablet || isDesktop ? 8 : 6),
                                const Text(
                                  "Fast Delivery",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                    height: isTablet || isDesktop ? 12 : 10),

                                // Price + Qty controls
                                Row(
                                  children: [
                                    Text(
                                      "₹${item['price']}",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: itemPriceSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            isTablet || isDesktop ? 12 : 10,
                                        vertical:
                                            isTablet || isDesktop ? 8 : 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.orange),
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
                                            child: Icon(Icons.remove,
                                                size: isTablet || isDesktop
                                                    ? 20
                                                    : 18),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: isTablet || isDesktop
                                                  ? 14
                                                  : 12,
                                            ),
                                            child: Text(
                                              item['qty'].toString(),
                                              style: TextStyle(
                                                fontSize: isTablet || isDesktop
                                                    ? 17
                                                    : 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              item['qty']++;
                                              box.putAt(index, item);
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.add,
                                              size: isTablet || isDesktop
                                                  ? 20
                                                  : 18,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                    height: isTablet || isDesktop ? 14 : 12),

                                // Remove button
                                GestureDetector(
                                  onTap: () {
                                    box.deleteAt(index);
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: isTablet || isDesktop ? 22 : 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Remove",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              isTablet || isDesktop ? 15 : 14,
                                        ),
                                      ),
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

              // ── Bill Summary Panel ──────────────────────────────────────
              Container(
                padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    // Coupon input
                    if (!couponApplied)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: couponController,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(
                                fontSize: isTablet || isDesktop ? 15 : 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "Enter coupon code",
                                prefixIcon: const Icon(
                                  Icons.local_offer_outlined,
                                  color: Colors.orange,
                                ),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: isTablet || isDesktop ? 16 : 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                vertical: isTablet || isDesktop ? 16 : 14,
                                horizontal: isTablet || isDesktop ? 20 : 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: isCheckingCoupon ? null : applyCoupon,
                            child: isCheckingCoupon
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Apply",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          isTablet || isDesktop ? 15 : 14,
                                    ),
                                  ),
                          ),
                        ],
                      ),

                    // Coupon applied banner
                    if (couponApplied)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet || isDesktop ? 16 : 14,
                          vertical: isTablet || isDesktop ? 12 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                couponMessage,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTablet || isDesktop ? 15 : 14,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: removeCoupon,
                              child: const Icon(Icons.close,
                                  color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),

                    // Coupon error message
                    if (couponMessage.isNotEmpty && !couponApplied)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              couponMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: isTablet || isDesktop ? 14 : 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: isTablet || isDesktop ? 20 : 16),

                    // Bill rows
                    _billRow("Item Total", "₹${totalPrice.toStringAsFixed(0)}",
                        fontSize: billFontSize),
                    SizedBox(height: isTablet || isDesktop ? 14 : 12),
                    _billRow("Delivery Fee", "₹40", fontSize: billFontSize),
                    SizedBox(height: isTablet || isDesktop ? 14 : 12),
                    _billRow("Taxes & Charges", "₹20", fontSize: billFontSize),

                    if (discountAmount > 0) ...[
                      SizedBox(height: isTablet || isDesktop ? 14 : 12),
                      _billRow(
                        "Coupon Discount",
                        "- ₹${discountAmount.toStringAsFixed(0)}",
                        isDiscount: true,
                        fontSize: billFontSize,
                      ),
                    ],

                    const Divider(height: 30),
                    _billRow(
                      "To Pay",
                      "₹${finalTotal.toStringAsFixed(0)}",
                      isBold: true,
                      fontSize: billFontSize + 1,
                    ),

                    SizedBox(height: isTablet || isDesktop ? 24 : 20),

                    // Pay button
                    SizedBox(
                      width: double.infinity,
                      height: payBtnHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () async {
                          if (couponApplied && appliedCoupon != null) {
                            final userId = Supabase
                                .instance.client.auth.currentUser?.id;
                            if (userId != null) {
                              final usageCheck = await Supabase
                                  .instance.client
                                  .from('coupon_usage')
                                  .select()
                                  .eq('coupon_code', appliedCoupon!['code'])
                                  .eq('user_id', userId)
                                  .maybeSingle();

                              if (usageCheck != null) {
                                removeCoupon();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Coupon already used. Proceeding without discount.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                            }
                          }

                          await recordCouponUsage();
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: payBtnFontSize,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _billRow(
    String title,
    String value, {
    bool isBold = false,
    bool isDiscount = false,
    double fontSize = 16,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
            color: isDiscount ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}