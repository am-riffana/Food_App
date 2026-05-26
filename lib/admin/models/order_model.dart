import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 1)
class OrderModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  double totalAmount;

  @HiveField(3)
  String status;

  @HiveField(4)
  String createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        id: map['id'],
        userId: map['user_id'] ?? '',
        totalAmount: (map['total_amount'] as num).toDouble(),
        status: map['status'] ?? 'pending',
        createdAt: map['created_at'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'total_amount': totalAmount,
        'status': status,
        'created_at': createdAt,
      };
}