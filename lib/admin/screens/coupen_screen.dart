import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CouponsPage extends StatefulWidget {
   const  CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final _supabase = Supabase.instance.client;
  List coupons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCoupons();
  }

  Future<void> loadCoupons() async {
    setState(() => isLoading = true);
    final data = await _supabase
        .from('coupons')
        .select()
        .order('created_at', ascending: false);
    setState(() {
      coupons = data;
      isLoading = false;
    });
  }

  void showCouponDialog({Map? coupon}) {
    final codeCtrl =
        TextEditingController(text: coupon?['code']);
    final valueCtrl = TextEditingController(
        text: coupon?['discount_value']?.toString());
    final minOrderCtrl = TextEditingController(
        text: coupon?['min_order_amount']?.toString() ?? '0');
    final maxDiscountCtrl = TextEditingController(
        text: coupon?['max_discount']?.toString() ?? '');
    String discountType = coupon?['discount_type'] ?? 'percentage';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                 SizedBox(height: 20),
                Text(
                  coupon == null ? "Add Coupon" : "Edit Coupon",
                  style:  TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                 SizedBox(height: 20),
                TextField(
                  controller: codeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    prefixIcon:  Icon(Icons.local_offer,
                        color: Colors.orange),
                    hintText: "Coupon Code (e.g. SAVE50)",
                    filled: true,
                    fillColor: Colors.orange.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                  ),
                ),
                 SizedBox(height: 16),

                Container(
                  padding:  EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                       Icon(Icons.percent, color: Colors.orange),
                       SizedBox(width: 12),
                       Text("Discount Type:",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                       Spacer(),
                      DropdownButton<String>(
                        value: discountType,
                        underline:  SizedBox(),
                        items:  [
                          DropdownMenuItem(
                              value: 'percentage',
                              child: Text('Percentage %')),
                          DropdownMenuItem(
                              value: 'fixed', child: Text('Fixed ₹')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => discountType = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 16),
                TextField(
                  controller: valueCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon:  Icon(Icons.discount,
                        color: Colors.orange),
                    hintText: discountType == 'percentage'
                        ? "Discount % (e.g. 10)"
                        : "Discount Amount ₹ (e.g. 50)",
                    filled: true,
                    fillColor: Colors.orange.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                  ),
                ),
                 SizedBox(height: 16),
                TextField(
                  controller: minOrderCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon:  Icon(Icons.shopping_cart,
                        color: Colors.orange),
                    hintText: "Min Order Amount ₹ (e.g. 200)",
                    filled: true,
                    fillColor: Colors.orange.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                  ),
                ),
                 SizedBox(height: 16),

                if (discountType == 'percentage')
                  TextField(
                    controller: maxDiscountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.money_off,
                          color: Colors.orange),
                      hintText: "Max Discount ₹ (optional)",
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                    ),
                  ),

                 SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () async {
                      if (codeCtrl.text.trim().isEmpty ||
                          valueCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                              content:
                                  Text("Enter coupon code and value"),
                              backgroundColor: Colors.red),
                        );
                        return;
                      }
                      try {
                        final data = {
                          'code': codeCtrl.text
                              .trim()
                              .toUpperCase(),
                          'discount_type': discountType,
                          'discount_value':
                              double.tryParse(valueCtrl.text) ?? 0,
                          'min_order_amount':
                              double.tryParse(minOrderCtrl.text) ?? 0,
                          'max_discount':
                              maxDiscountCtrl.text.trim().isEmpty
                                  ? null
                                  : double.tryParse(
                                      maxDiscountCtrl.text),
                          'is_active': true,
                        };

                        if (coupon == null) {
                          await _supabase
                              .from('coupons')
                              .insert(data);
                        } else {
                          await _supabase
                              .from('coupons')
                              .update(data)
                              .eq('id', coupon['id']);
                        }

                        Navigator.pop(context);
                        loadCoupons();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(coupon == null
                                ? "Coupon added!"
                                : "Coupon updated!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red),
                        );
                      }
                    },
                    child: Text(
                      coupon == null ? "Add Coupon" : "Update Coupon",
                      style:  TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> toggleCoupon(String id, bool current) async {
    await _supabase
        .from('coupons')
        .update({'is_active': !current})
        .eq('id', id);
    loadCoupons();
  }

  Future<void> deleteCoupon(String id) async {
    await _supabase.from('coupons').delete().eq('id', id);
    loadCoupons();
  }

  Color _typeColor(String type) =>
      type == 'percentage' ? Colors.blue : Colors.purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Manage Coupons'),
        actions: [
          IconButton(onPressed: loadCoupons, icon:  Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => showCouponDialog(),
        child:  Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ?  Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : coupons.isEmpty
              ?  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_offer,
                          size: 80, color: Colors.orange),
                      SizedBox(height: 16),
                      Text("No coupons yet",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Tap + to create a coupon",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding:  EdgeInsets.all(14),
                  itemCount: coupons.length,
                  itemBuilder: (_, i) {
                    final coupon = coupons[i];
                    final isActive = coupon['is_active'] ?? true;
                    final type = coupon['discount_type'] ?? 'percentage';

                    return Opacity(
                      opacity: isActive ? 1.0 : 0.5,
                      child: Container(
                        margin:  EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset:  Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // CODE
                                  Container(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.orange.shade200,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Text(
                                      coupon['code'],
                                      style:  TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          letterSpacing: 1.5),
                                    ),
                                  ),
                                   Spacer(),
                                  // TYPE BADGE
                                  Container(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _typeColor(type)
                                          .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      type == 'percentage'
                                          ? '${coupon['discount_value']}% OFF'
                                          : '₹${coupon['discount_value']} OFF',
                                      style: TextStyle(
                                          color: _typeColor(type),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ),
                                   SizedBox(width: 8),
                                  // ACTIVE BADGE
                                  Container(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isActive ? 'Active' : 'Inactive',
                                      style: TextStyle(
                                          color: isActive
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height: 12),
                              Text(
                                'Min order: ₹${coupon['min_order_amount'] ?? 0}',
                                style:  TextStyle(
                                    color: Colors.grey, fontSize: 13),
                              ),
                              if (coupon['max_discount'] != null)
                                Text(
                                  'Max discount: ₹${coupon['max_discount']}',
                                  style:  TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                               SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      onPressed: () =>
                                          showCouponDialog(coupon: coupon),
                                      icon:  Icon(Icons.edit,
                                          color: Colors.white, size: 16),
                                      label:  Text("Edit",
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                   SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isActive
                                            ? Colors.red
                                            : Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => toggleCoupon(
                                          coupon['id'], isActive),
                                      icon: Icon(
                                        isActive
                                            ? Icons.block
                                            : Icons.check_circle,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      label: Text(
                                        isActive ? "Disable" : "Enable",
                                        style:  TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    onPressed: () =>
                                        deleteCoupon(coupon['id']),
                                    child:  Icon(Icons.delete,
                                        color: Colors.white, size: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}