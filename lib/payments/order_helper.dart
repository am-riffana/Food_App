import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

Future<void> saveOrderToSupabase({required String paymentMethod}) async {
  final cartBox = Hive.box('orders');
  final items = cartBox.values.toList();

  print('🛒 Cart items count: ${items.length}'); 

  if (items.isEmpty) {
    print('❌ Cart is empty, nothing to save!'); 
    return;
  }

  final supabase = Supabase.instance.client;
  final orderId = const Uuid().v4();
  final now = DateTime.now().toIso8601String();

  double total = 0;
  for (var item in items) {
    total += (item['price'] * item['qty']);
  }

  final orderData = {
    'id': orderId,
    'user_id': 'guest',
    'items': items
        .map((e) => {
              'name': e['name'],
              'price': e['price'],
              'qty': e['qty'],
              'image': e['image'],
            })
        .toList(),
    'total_amount': total + 60,
    'payment_method': paymentMethod,
    'status': 'pending',
    'created_at': now,
  };

  print('📦 Saving order: $orderData'); 

  try {
    await supabase.from('orders').insert(orderData);
    print('✅ Order saved to Supabase!');
  } catch (e) {
    print('❌ Supabase insert failed: $e'); 
  }

  await cartBox.clear();
  print('🧹 Cart cleared'); 
}