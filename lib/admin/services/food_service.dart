import 'package:foodapp/admin/models/food_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {
  static const _boxName = 'admin_foods';
  final _supabase = Supabase.instance.client;

  Box<FoodModel> get _box => Hive.box<FoodModel>(_boxName);

  static Future<void> init() async {
    Hive.registerAdapter(FoodModelAdapter());
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<FoodModel>(_boxName);
    }
  }

  Future<List<FoodModel>> getFoods() async {
    try {
      final data = await _supabase.from('foods').select();
      final foods = (data as List)
          .map((e) => FoodModel.fromMap(e))
          .toList();
      await _box.clear();
      for (var food in foods) {
        await _box.put(food.id, food);
      }
      return foods;
    } catch (e) {
      return _box.values.toList();
    }
  }

  Future<void> addFood(FoodModel food) async {
    try {
      await _supabase.from('foods').insert(food.toMap());
      await _box.put(food.id, food);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFood(FoodModel food) async {
    try {
      await _supabase.from('foods').update(food.toMap()).eq('id', food.id);
      await _box.put(food.id, food);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFood(String id) async {
    try {
      await _supabase.from('foods').delete().eq('id', id);
      await _box.delete(id);
    } catch (e) {
      rethrow;
    }
  }
}