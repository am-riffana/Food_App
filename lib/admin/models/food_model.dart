import 'package:hive/hive.dart';

part 'food_model.g.dart';

@HiveType(typeId: 0)
class FoodModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  double price;

  @HiveField(4)
  String category;

  @HiveField(5)
  String imageUrl;

  @HiveField(6)
  bool isAvailable;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory FoodModel.fromMap(Map<String, dynamic> map) => FoodModel(
        id: map['id'],
        name: map['name'],
        description: map['description'] ?? '',
        price: (map['price'] as num).toDouble(),
        category: map['category'] ?? '',
        imageUrl: map['image_url'] ?? '',
        isAvailable: map['is_available'] ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'image_url': imageUrl,
        'is_available': isAvailable,
      };
}