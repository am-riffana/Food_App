import 'package:foodapp/admin/models/food_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {
  static const String _boxName = 'admin_foods';

  final SupabaseClient _supabase = Supabase.instance.client;

  Box<FoodModel> get _box => Hive.box<FoodModel>(_boxName);

  /// Initialize Hive adapter + box
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FoodModelAdapter());
    }

    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<FoodModel>(_boxName);
    }
  }

  /// Fetch foods from Supabase → cache locally → return list
  Future<List<FoodModel>> getFoods() async {
    try {
      final response = await _supabase.from('foods').select();

      final List<FoodModel> foods = (response as List)
          .map((e) => FoodModel.fromMap(e))
          .toList();

      await _box.clear();

      for (final food in foods) {
        await _box.put(food.id, food);
      }

      return foods;
    } catch (e) {
      // fallback to local cache
      return _box.values.toList();
    }
  }

  /// Add food (Supabase + Hive)
  Future<void> addFood(FoodModel food) async {
    try {
      await _supabase.from('foods').insert(food.toMap());

      await _box.put(food.id, food);
    } catch (e) {
      rethrow;
    }
  }

  /// Update food (Supabase + Hive)
  Future<void> updateFood(FoodModel food) async {
    try {
      await _supabase
          .from('foods')
          .update(food.toMap())
          .eq('id', food.id);

      await _box.put(food.id, food);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete food (Supabase + Hive)
  Future<void> deleteFood(String id) async {
    try {
      await _supabase.from('foods').delete().eq('id', id);

      await _box.delete(id);
    } catch (e) {
      rethrow;
    }
  }
}