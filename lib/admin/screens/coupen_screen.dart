import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

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
    final codeCtrl = TextEditingController(text: coupon?['code']);
    final valueCtrl = TextEditingController(
      text: coupon?['discount_value']?.toString(),
    );
    final minOrderCtrl = TextEditingController(
      text: coupon?['min_order_amount']?.toString() ?? '0',
    );
    final maxDiscountCtrl = TextEditingController(
      text: coupon?['max_discount']?.toString() ?? '',
    );

    String discountType = coupon?['discount_type'] ?? 'percentage';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          final w = MediaQuery.of(context).size.width;

          return Container(
            padding: EdgeInsets.only(
              left: w * 0.05,
              right: w * 0.05,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                  const SizedBox(height: 20),

                  Text(
                    coupon == null ? "Add Coupon" : "Edit Coupon",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _field(codeCtrl, "Coupon Code", Icons.local_offer),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.percent, color: Colors.orange),
                      const SizedBox(width: 10),
                      const Text("Type:"),
                      const Spacer(),
                      DropdownButton<String>(
                        value: discountType,
                        items: const [
                          DropdownMenuItem(
                              value: 'percentage',
                              child: Text('Percentage')),
                          DropdownMenuItem(
                              value: 'fixed', child: Text('Fixed')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => discountType = val);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _field(valueCtrl, "Discount Value", Icons.discount,
                      type: TextInputType.number),

                  const SizedBox(height: 16),

                  _field(minOrderCtrl, "Min Order", Icons.shopping_cart,
                      type: TextInputType.number),

                  const SizedBox(height: 16),

                  if (discountType == 'percentage')
                    _field(maxDiscountCtrl, "Max Discount (optional)",
                        Icons.money_off,
                        type: TextInputType.number),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        final data = {
                          'code': codeCtrl.text.trim().toUpperCase(),
                          'discount_type': discountType,
                          'discount_value':
                              double.tryParse(valueCtrl.text) ?? 0,
                          'min_order_amount':
                              double.tryParse(minOrderCtrl.text) ?? 0,
                          'max_discount': maxDiscountCtrl.text.isEmpty
                              ? null
                              : double.tryParse(maxDiscountCtrl.text),
                          'is_active': true,
                        };

                        if (coupon == null) {
                          await _supabase.from('coupons').insert(data);
                        } else {
                          await _supabase
                              .from('coupons')
                              .update(data)
                              .eq('id', coupon['id']);
                        }

                        Navigator.pop(context);
                        loadCoupons();
                      },
                      child: Text(
                        coupon == null ? "Add Coupon" : "Update Coupon",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String hint,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orange),
        hintText: hint,
        filled: true,
        fillColor: Colors.orange.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
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
    final w = MediaQuery.of(context).size.width;

    int crossAxis() {
      if (w > 1000) return 3;
      if (w > 700) return 2;
      return 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Coupons"),
        actions: [
          IconButton(onPressed: loadCoupons, icon: const Icon(Icons.refresh))
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => showCouponDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : coupons.isEmpty
              ? const Center(child: Text("No coupons"))
              : Padding(
                  padding: EdgeInsets.all(w * 0.03),
                  child: GridView.builder(
                    itemCount: coupons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxis(),
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (_, i) {
                      final coupon = coupons[i];
                      final isActive = coupon['is_active'] ?? true;
                      final type = coupon['discount_type'] ?? 'percentage';

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  coupon['code'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _typeColor(type).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    type == 'percentage'
                                        ? "${coupon['discount_value']}%"
                                        : "₹${coupon['discount_value']}",
                                    style:
                                        TextStyle(color: _typeColor(type)),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text("Min: ₹${coupon['min_order_amount']}"),

                            const Spacer(),

                            Wrap(
                              spacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      showCouponDialog(coupon: coupon),
                                  child: const Text("Edit"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isActive ? Colors.red : Colors.green,
                                  ),
                                  onPressed: () =>
                                      toggleCoupon(coupon['id'], isActive),
                                  child: Text(
                                      isActive ? "Disable" : "Enable"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () =>
                                      deleteCoupon(coupon['id']),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                              ],
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