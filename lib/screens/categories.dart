import 'package:flutter/material.dart';
import 'package:foodapp/screens/cart.dart';
import 'package:foodapp/widgets/filter.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() =>
      _CategoriesPageState();
}

class _CategoriesPageState
    extends State<CategoriesPage> {

  String selectedFilter = "All";

  List<Map<String, dynamic>> cartItems = [];

  final List<Map<String, dynamic>> foodItems = [

    {
      "name": "Burger",
      "price": 120,
      "rating": 4.5,
      "time": "20 min",
      "image":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd",
    },

    {
      "name": "Pizza",
      "price": 280,
      "rating": 4.8,
      "time": "30 min",
      "image":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591",
    },

    {
      "name": "Biriyani",
      "price": 190,
      "rating": 4.7,
      "time": "25 min",
      "image":
          "https://images.unsplash.com/photo-1701579231349-d7459c40919d",
    },

    {
      "name": "Shawarma",
      "price": 140,
      "rating": 4.4,
      "time": "18 min",
      "image":
          "https://images.unsplash.com/photo-1529006557810-274b9b2fc783",
    },

    {
      "name": "Pasta",
      "price": 220,
      "rating": 4.3,
      "time": "22 min",
      "image":
          "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9",
    },

    {
      "name": "Ice Cream",
      "price": 90,
      "rating": 4.2,
      "time": "10 min",
      "image":
          "https://images.unsplash.com/photo-1563805042-7684c019e1cb",
    },
  ];

  List<Map<String, dynamic>>
      get filteredItems {

    if (selectedFilter ==
        "Low Price") {

      return foodItems
          .where(
            (e) => e["price"] <= 150,
          )
          .toList();
    }

    if (selectedFilter ==
        "High Rating") {

      return foodItems
          .where(
            (e) => e["rating"] >= 4.5,
          )
          .toList();
    }

    return foodItems;
  }

  void addToCart(
      Map<String, dynamic> item) {

    setState(() {
      cartItems.add(item);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        backgroundColor:
            Colors.orange,

        content: Text(
          "${item["name"]} added to cart",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor:
            Colors.orange,

        elevation: 0,

        title: const Text(
          "Food Items",

          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        actions: [

          /// FILTER
          IconButton(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FilterPage(
                    currentFilter:
                        selectedFilter,

                    onSelected:
                        (value) {

                      setState(() {
                        selectedFilter =
                            value;
                      });

                    },
                  ),
                ),
              );

            },

            icon: const Icon(
              Icons.tune,
              color: Colors.white,
            ),
          ),

          /// CART
          Stack(
            children: [

              IconButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CartPage(),
                    ),
                  );

                },

                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
              ),

              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,

                  child: Container(
                    padding:
                        const EdgeInsets.all(
                      5,
                    ),

                    decoration:
                        const BoxDecoration(
                      color: Colors.red,
                      shape:
                          BoxShape.circle,
                    ),

                    child: Text(
                      cartItems.length
                          .toString(),

                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [

          /// FILTERS
          SizedBox(
            height: 60,

            child: ListView(
              scrollDirection:
                  Axis.horizontal,

              padding:
                  const EdgeInsets.all(
                12,
              ),

              children: [

                filterItem("All"),

                filterItem(
                    "Low Price"),

                filterItem(
                    "High Rating"),
              ],
            ),
          ),

          /// GRID
          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.all(
                14,
              ),

              itemCount:
                  filteredItems.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

                crossAxisSpacing:
                    14,

                mainAxisSpacing:
                    14,

                childAspectRatio:
                    0.70,
              ),

              itemBuilder:
                  (context, index) {

                final item =
                    filteredItems[index];

                return Container(
                  decoration:
                      BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black12,

                        blurRadius: 6,

                        offset:
                            const Offset(
                          0,
                          3,
                        ),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      /// IMAGE
                      Expanded(
                        flex: 6,

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

                                fit:
                                    BoxFit.cover,
                              ),
                            ),

                            Positioned(
                              left: 8,
                              bottom: 8,

                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal:
                                      8,
                                  vertical:
                                      4,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.black87,

                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),

                                child: Text(
                                  item["time"],

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
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// DETAILS
                      Expanded(
                        flex: 5,

                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            10,
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                item["name"],

                                maxLines: 1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style:
                                    const TextStyle(
                                  fontSize: 16,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 6),

                              Row(
                                children: [

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal:
                                          6,
                                      vertical:
                                          3,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors.green,

                                      borderRadius:
                                          BorderRadius.circular(
                                        8,
                                      ),
                                    ),

                                    child: Row(
                                      children: [

                                        const Icon(
                                          Icons.star,
                                          size: 12,
                                          color:
                                              Colors.white,
                                        ),

                                        const SizedBox(
                                            width:
                                                3),

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

                                  const Spacer(),

                                  Text(
                                    "₹${item["price"]}",

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.orange,

                                      fontSize:
                                          17,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              SizedBox(
                                width:
                                    double.infinity,

                                height: 40,

                                child:
                                    ElevatedButton(
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.orange,

                                    elevation: 0,

                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                  ),

                                  onPressed:
                                      () {

                                    addToCart(
                                      item,
                                    );

                                  },

                                  child:
                                      const Icon(
                                    Icons.add,
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }

  Widget filterItem(String title) {

    bool isSelected =
        selectedFilter == title;

    return GestureDetector(
      onTap: () {

        setState(() {
          selectedFilter = title;
        });

      },

      child: Container(
        margin:
            const EdgeInsets.only(
          right: 10,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange
              : Colors.white,

          borderRadius:
              BorderRadius.circular(
            30,
          ),

          border: Border.all(
            color: isSelected
                ? Colors.orange
                : Colors.grey.shade300,
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.black,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}