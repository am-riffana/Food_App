import 'package:foodapp/admin/models/order_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  static const _boxName = 'admin_orders'; // ✅ changed
  final _supabase = Supabase.instance.client;

  Box<OrderModel> get _box => Hive.box<OrderModel>(_boxName);

  static Future<void> init() async {
    Hive.registerAdapter(OrderModelAdapter());
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<OrderModel>(_boxName);
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final data = await _supabase
          .from('orders')
          .select()
          .order('created_at', ascending: false);
      final orders = (data as List)
          .map((e) => OrderModel.fromMap(e))
          .toList();
      await _box.clear();
      for (var order in orders) {
        await _box.put(order.id, order);
      }
      return orders;
    } catch (e) {
      return _box.values.toList();
    }
  }

  Future<void> updateOrderStatus(String id, String status) async {
    await _supabase.from('orders').update({'status': status}).eq('id', id);
    final order = _box.get(id);
    if (order != null) {
      order.status = status;
      await order.save();
    }
  }
}