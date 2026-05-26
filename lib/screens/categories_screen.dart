import 'package:flutter/material.dart';
import 'package:foodapp/screens/cart_screen.dart';
import 'package:foodapp/widgets/filter.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() =>
      _CategoriesPageState();
}

class _CategoriesPageState
    extends State<CategoriesPage> {
  late Box ordersBox;

  List<Map<String, dynamic>> allFoods = [];

  List<Map<String, dynamic>> localFoods = [
    {
      "name": "Chicken Biryani",
      "category": "Indian",
      "description":
          "Aromatic basmati rice cooked with tender chicken and spices",
      "price": 220,
      "rating": 4.8,
      "time": "30 min",
      "distance": "1.2 km",
      "delivery": "Fast Delivery",
      "image_url":
          "https://images.unsplash.com/photo-1701579231349-d7459c40919d",
    },

    {
      "name": "Butter Chicken",
      "category": "Indian",
      "description":
          "Creamy tomato based curry with tender chicken pieces",
      "price": 260,
      "rating": 4.7,
      "time": "25 min",
      "distance": "0.8 km",
      "delivery": "Fast Delivery",
      "image_url":
          "https://images.unsplash.com/photo-1603894584373-5ac82b2ae398",
    },

    {
      "name": "Margherita Pizza",
      "category": "International",
      "description":
          "Classic Italian pizza with fresh tomato and mozzarella",
      "price": 299,
      "rating": 4.6,
      "time": "25 min",
      "distance": "1.8 km",
      "delivery": "Fast Delivery",
      "image_url":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591",
    },

    {
      "name": "Shawarma",
      "category": "Arabic",
      "description":
          "Middle Eastern wrap with grilled meat and garlic sauce",
      "price": 140,
      "rating": 4.5,
      "time": "15 min",
      "distance": "0.7 km",
      "delivery": "Fast Delivery",
      "image_url":
          "https://images.unsplash.com/photo-1529006557810-274b9b2fc783",
    },

    {
      "name": "Chicken Noodles",
      "category": "Chinese",
      "description":
          "Stir fried noodles with chicken and vegetables",
      "price": 160,
      "rating": 4.4,
      "time": "20 min",
      "distance": "1.4 km",
      "delivery": "Fast Delivery",
      "image_url":
          "https://images.unsplash.com/photo-1612929633738-8fe44f7ec841",
    },
  ];

  List<String> categories = [
    'All',
    'Indian',
    'International',
    'Arabic',
    'Chinese',
  ];

  String selectedCategory = 'All';
  String selectedFilter = 'All';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    ordersBox = Hive.box('orders');

    loadFoods();
  }

  Future<void> loadFoods() async {
    setState(() => isLoading = true);

    try {
      final data = await Supabase.instance.client
          .from('foods')
          .select()
          .eq('is_available', true);

      final supabaseFoods =
          List<Map<String, dynamic>>.from(data);

      for (var food in supabaseFoods) {
        if (food['category'] != null &&
            !categories.contains(
                food['category'])) {
          categories.add(food['category']);
        }
      }

      setState(() {
        allFoods = [
          ...localFoods,
          ...supabaseFoods,
        ];

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        allFoods = localFoods;
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredFoods {
    List<Map<String, dynamic>> list =
        List.from(allFoods);

    if (selectedCategory != 'All') {
      list = list.where((f) {
        return f['category'] ==
            selectedCategory;
      }).toList();
    }

    switch (selectedFilter) {
      case 'Low Price':
        list.sort(
          (a, b) => (a['price'] as num)
              .compareTo(b['price'] as num),
        );
        break;

      case 'High Rating':
        list.sort(
          (a, b) => (b['rating'] as num)
              .compareTo(a['rating'] as num),
        );
        break;

      case 'Fast Delivery':
        list = list.where((f) {
          return f['delivery'] ==
              'Fast Delivery';
        }).toList();
        break;

      case 'Nearest':
        list.sort((a, b) {
          final aD = double.tryParse(
                  a['distance']
                          ?.toString()
                          .replaceAll(
                              ' km', '') ??
                      '99') ??
              99;

          final bD = double.tryParse(
                  b['distance']
                          ?.toString()
                          .replaceAll(
                              ' km', '') ??
                      '99') ??
              99;

          return aD.compareTo(bD);
        });

        break;
    }

    return list;
  }

  void addToCart(
      Map<String, dynamic> item) {
    final data = {
      "name": item["name"],
      "price": item["price"],
      "image": item["image_url"] ?? "",
      "qty": 1,
    };

    int index = ordersBox.values
        .toList()
        .indexWhere(
          (e) => e['name'] == item['name'],
        );

    if (index != -1) {
      final existing =
          Map<String, dynamic>.from(
              ordersBox.getAt(index));

      existing['qty'] =
          (existing['qty'] ?? 1) + 1;

      ordersBox.putAt(index, existing);
    } else {
      ordersBox.add(data);
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
            "${item['name']} added to cart"),

        backgroundColor: Colors.green,

        action: SnackBarAction(
          label: "View Cart",
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const CartPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F5F5),

      body: SafeArea(
        child: Column(
          children: [
            /// TOP HEADER
            Container(
              color: Colors.white,

              padding:
                  const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                12,
              ),

              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      final result =
                          await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FilterPage(
                            selectedFilter:
                                selectedFilter,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          selectedFilter =
                              result;
                        });
                      }
                    },

                    child: Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color:
                            selectedFilter !=
                                    'All'
                                ? Colors.orange
                                : Colors.orange
                                    .shade50,

                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),

                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: selectedFilter !=
                                    'All'
                                ? Colors.white
                                : Colors.orange,
                          ),

                          const SizedBox(
                              width: 6),

                          Text(
                            selectedFilter ==
                                    'All'
                                ? "Filter"
                                : selectedFilter,

                            style: TextStyle(
                              color: selectedFilter !=
                                      'All'
                                  ? Colors.white
                                  : Colors.orange,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// CATEGORY CHIPS
            Container(
              color: Colors.white,
              height: 55,

              child: ListView.builder(
                scrollDirection:
                    Axis.horizontal,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                itemCount: categories.length,

                itemBuilder: (_, i) {
                  final cat =
                      categories[i];

                  final isSelected =
                      selectedCategory ==
                          cat;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory =
                            cat;
                      });
                    },

                    child: Container(
                      margin:
                          const EdgeInsets.only(
                              right: 8),

                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.orange
                            : Colors.grey
                                .shade100,

                        borderRadius:
                            BorderRadius
                                .circular(30),
                      ),

                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 6),

            /// FOOD LIST
            Expanded(
              child: isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(
                        color:
                            Colors.orange,
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets
                              .all(14),

                      itemCount:
                          filteredFoods.length,

                      itemBuilder: (_, i) {
                        return _foodCard(
                          filteredFoods[i],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodCard(
      Map<String, dynamic> food) {
    final imageUrl =
        food['image_url'] ?? '';

    return Container(
      margin:
          const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          /// IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),

                child: Image.network(
                  imageUrl,
                  height: 210,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (_, __, ___) => Container(
                    height: 210,
                    color:
                        Colors.orange.shade50,
                    child: const Icon(
                      Icons.fastfood,
                      color: Colors.orange,
                      size: 60,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 12,
                left: 12,

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),

                  child: Text(
                    food['category'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding:
                const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                /// NAME + RATING
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        food['name'] ?? '',
                        style:
                            const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            BorderRadius
                                .circular(8),
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color:
                                Colors.white,
                            size: 14,
                          ),

                          const SizedBox(
                              width: 3),

                          Text(
                            food['rating']
                                .toString(),

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  food['description'] ?? '',

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 12),

                /// DETAILS
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.orange,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      food['distance'] ?? '',
                    ),

                    const SizedBox(width: 16),

                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.orange,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      food['time'] ?? '',
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// PRICE + BUTTON
                Row(
                  children: [
                    Text(
                      "₹${food['price']}",

                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton.icon(
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Colors.orange,

                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(16),
                        ),
                      ),

                      onPressed: () =>
                          addToCart(food),

                      icon: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 18,
                      ),

                      label: const Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}