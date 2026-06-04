import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 1)
class OrderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final double totalAmount;

  @HiveField(3)
  String status;

  @HiveField(4)
  final String createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: (map['id'] ?? '').toString(),
      userId: (map['user_id'] ?? '').toString(),
      totalAmount: (map['total_amount'] ?? 0).toDouble(),
      status: (map['status'] ?? 'pending').toString(),
      createdAt: (map['created_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt,
    };
  }
}