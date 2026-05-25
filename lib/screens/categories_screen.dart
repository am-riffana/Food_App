import 'package:flutter/material.dart';
import 'package:foodapp/screens/cart_screen.dart';
import 'package:foodapp/widgets/filter.dart';
import 'package:hive/hive.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Box ordersBox;

  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    ordersBox = Hive.box('orders');
  }

  /// FOOD DATA
  final List<Map<String, dynamic>> foodItems = [
   {
  "name": "Chicken Fry",
  "price": 240,
  "rating": 4.6,
  "time": "25 min",
  "image":
      "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec",
  "type": "Non Veg",
  "spicy": true,
  "premium": true,
  "dessert": false,
},
   {
  "name": "Falooda",
  "price": 110,
  "rating": 4.4,
  "time": "12 min",
  "image":
      "https://images.unsplash.com/photo-1579954115545-a95591f28bfc",
  "type": "Veg",
  "spicy": false,
  "premium": false,
  "dessert": true,
},
    {
      "name": "Biriyani",
      "price": 190,
      "rating": 4.7,
      "time": "25 min",
      "image":
          "https://images.unsplash.com/photo-1701579231349-d7459c40919d",
      "type": "Non Veg",
      "spicy": true,
      "premium": true,
      "dessert": false,
    },
    {
  "name": "Momos",
  "price": 150,
  "rating": 4.5,
  "time": "18 min",
  "image":
      "https://images.unsplash.com/photo-1626776876729-bab4369a5a5d",
  "type": "Veg",
  "spicy": true,
  "premium": false,
  "dessert": false,
},
{
  "name": "Sandwich",
  "price": 100,
  "rating": 4.1,
  "time": "10 min",
  "image":
      "https://images.unsplash.com/photo-1528735602780-2552fd46c7af",
  "type": "Veg",
  "spicy": false,
  "premium": false,
  "dessert": false,
},
{
  "name": "Tandoori Chicken",
  "price": 320,
  "rating": 4.9,
  "time": "35 min",
  "image":
      "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0",
  "type": "Non Veg",
  "spicy": true,
  "premium": true,
  "dessert": false,
},
{
  "name": "Chocolate Cake",
  "price": 180,
  "rating": 4.8,
  "time": "15 min",
  "image":
      "https://images.unsplash.com/photo-1578985545062-69928b1d9587",
  "type": "Veg",
  "spicy": false,
  "premium": true,
  "dessert": true,
},
{
  "name": "French Fries",
  "price": 90,
  "rating": 4.2,
  "time": "8 min",
  "image":
      "https://images.unsplash.com/photo-1576107232684-1279f390859f",
  "type": "Veg",
  "spicy": false,
  "premium": false,
  "dessert": false,
},
{
  "name": "Alfaham",
  "price": 290,
  "rating": 4.7,
  "time": "30 min",
  "image":
      "https://images.unsplash.com/photo-1603360946369-dc9bb6258143",
  "type": "Non Veg",
  "spicy": true,
  "premium": true,
  "dessert": false,
},
{
  "name": "Donut",
  "price": 130,
  "rating": 4.3,
  "time": "10 min",
  "image":
      "https://images.unsplash.com/photo-1551024601-bec78aea704b",
  "type": "Veg",
  "spicy": false,
  "premium": false,
  "dessert": true,
},
{
  "name": "Paneer Butter Masala",
  "price": 260,
  "rating": 4.6,
  "time": "28 min",
  "image":
      "https://images.unsplash.com/photo-1631452180519-c014fe946bc7",
  "type": "Veg",
  "spicy": true,
  "premium": true,
  "dessert": false,
},
{
  "name": "Hot Dog",
  "price": 170,
  "rating": 4.4,
  "time": "14 min",
  "image":
      "https://images.unsplash.com/photo-1612392062798-29b64c6b7f2d",
  "type": "Non Veg",
  "spicy": false,
  "premium": false,
  "dessert": false,
},
{
  "name": "Cup Cake",
  "price": 95,
  "rating": 4.5,
  "time": "9 min",
  "image":
      "https://images.unsplash.com/photo-1486427944299-d1955d23e34d",
  "type": "Veg",
  "spicy": false,
  "premium": false,
  "dessert": true,
},
    {
      "name": "Shawarma",
      "price": 140,
      "rating": 4.4,
      "time": "18 min",
      "image":
          "https://images.unsplash.com/photo-1529006557810-274b9b2fc783",
      "type": "Non Veg",
      "spicy": true,
      "premium": false,
      "dessert": false,
    },
    {
      "name": "Pasta",
      "price": 220,
      "rating": 4.3,
      "time": "22 min",
      "image":
          "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9",
      "type": "Veg",
      "spicy": false,
      "premium": true,
      "dessert": false,
    },
    {
      "name": "Ice Cream",
      "price": 90,
      "rating": 4.2,
      "time": "10 min",
      "image":
          "https://images.unsplash.com/photo-1563805042-7684c019e1cb",
      "type": "Veg",
      "spicy": false,
      "premium": false,
      "dessert": true,
    },
    {
      "name": "Noodles",
      "price": 130,
      "rating": 4.3,
      "time": "15 min",
      "image":
          "https://images.unsplash.com/photo-1612929633738-8fe44f7ec841",
      "type": "Veg",
      "spicy": true,
      "premium": false,
      "dessert": false,
    },
    {
      "name": "Fried Rice",
      "price": 160,
      "rating": 4.4,
      "time": "20 min",
      "image":
          "https://images.unsplash.com/photo-1604908177522-040c3b5f3f1d",
      "type": "Non Veg",
      "spicy": false,
      "premium": false,
      "dessert": false,
    },
  ];

  /// FILTER LOGIC
  List<Map<String, dynamic>> get filteredItems {
    switch (selectedFilter) {
      case "Low Price":
        return foodItems.where((e) => e["price"] <= 150).toList();

      case "High Rating":
        return foodItems.where((e) => e["rating"] >= 4.5).toList();

      case "Premium":
        return foodItems.where((e) => e["premium"] == true).toList();

      case "Fast Delivery":
        return foodItems.where(
          (e) => int.parse(e["time"].split(" ")[0]) <= 20,
        ).toList();

      case "Veg Only":
        return foodItems.where((e) => e["type"] == "Veg").toList();

      case "Non Veg":
        return foodItems.where((e) => e["type"] == "Non Veg").toList();

      case "Spicy":
        return foodItems.where((e) => e["spicy"] == true).toList();

      case "Desserts":
        return foodItems.where((e) => e["dessert"] == true).toList();

      case "Best Seller":
        return foodItems.where((e) => e["rating"] >= 4.5).toList();

      case "Healthy":
        return foodItems.where((e) => e["price"] <= 150).toList();

      case "New Arrivals":
        return foodItems.reversed.toList();

      case "All":
      default:
        return foodItems;
    }
  }

  /// ADD TO CART
  void addToCart(Map<String, dynamic> item) {
    final data = {
      "name": item["name"],
      "price": item["price"],
      "image": item["image"],
      "qty": 1,
    };

    int index = ordersBox.values.toList().indexWhere(
          (e) => e['name'] == item['name'],
        );

    if (index != -1) {
      final existing = Map<String, dynamic>.from(
        ordersBox.getAt(index),
      );

      existing['qty'] = (existing['qty'] ?? 1) + 1;

      ordersBox.putAt(index, existing);
    } else {
      ordersBox.add(data);
    }

    setState(() {});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "What’s on your mind?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// FILTER BUTTON
                  IconButton(
                    onPressed: () async {
                      final result =
                          await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FilterPage(
                            currentFilter:
                                selectedFilter,
                          ),
                        ),
                      );

                      if (result != null &&
                          mounted) {
                        setState(() {
                          selectedFilter = result;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.tune,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            /// GRID
            Expanded(
              child: GridView.builder(
                padding:
                    const EdgeInsets.all(12),

                itemCount:
                    filteredItems.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),

                itemBuilder: (
                  context,
                  index,
                ) {
                  final item =
                      filteredItems[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Column(
                      children: [
                        /// IMAGE
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.only(
                                  topLeft:
                                      Radius.circular(
                                    20,
                                  ),
                                  topRight:
                                      Radius.circular(
                                    20,
                                  ),
                                ),

                                child:
                                    Image.network(
                                  item["image"],
                                  width:
                                      double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              /// RATING
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        6,
                                    vertical: 3,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        Colors.green,
                                    borderRadius:
                                        BorderRadius.circular(
                                      6,
                                    ),
                                  ),

                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors
                                            .white,
                                      ),

                                      const SizedBox(
                                        width: 3,
                                      ),

                                      Text(
                                        item["rating"]
                                            .toString(),

                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize:
                                              11,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// TIME
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        6,
                                    vertical: 3,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color: Colors
                                        .black87,

                                    borderRadius:
                                        BorderRadius.circular(
                                      6,
                                    ),
                                  ),

                                  child: Text(
                                    item["time"],

                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                          11,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DETAILS
                        Padding(
                          padding:
                              const EdgeInsets.all(
                            8,
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                item["name"],

                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 6),

                              Text(
                                "₹${item["price"]}",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.orange,
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              SizedBox(
                                width:
                                    double.infinity,
                                height: 35,

                                child:
                                    ElevatedButton(
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.orange,

                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),

                                  onPressed: () =>
                                      addToCart(
                                    item,
                                  ),

                                  child:
                                      const Text(
                                    "Add",

                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}