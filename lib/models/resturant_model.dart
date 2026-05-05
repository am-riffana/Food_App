class Restaurant {
  final String name;
  final String rating;
  final String distance;
  final bool isOpen;
  final List<String> images;
  final int price;
  final String category;

  Restaurant({
    required this.name,
    required this.rating,
    required this.distance,
    required this.isOpen,
    required this.images,
    required this.price,
    required this.category,
  });

  /// 🔥 Convert to Map (for Hive / storage)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'distance': distance,
      'isOpen': isOpen,
      'images': images,
      'price': price,
      'category': category,
    };
  }

  /// 🔥 Convert from Map (for reading data)
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      name: map['name'] ?? '',
      rating: map['rating'] ?? '0.0',
      distance: map['distance'] ?? '',
      isOpen: map['isOpen'] ?? false,
      images: List<String>.from(map['images'] ?? []),
      price: map['price'] ?? 0,
      category: map['category'] ?? '',
    );
  }
}