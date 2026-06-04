import 'package:flutter/material.dart';
import 'package:foodapp/screens/profile_screen.dart';
import 'package:foodapp/widgets/notification_page.dart';
import 'package:foodapp/widgets/big_resturant.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:foodapp/widgets/resturant_model.dart';
import 'package:foodapp/widgets/search.dart';
import 'package:foodapp/widgets/slide_banner.dart';

class HomePage extends StatefulWidget {
  const  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  String _searchText = "";

  final TextEditingController _searchController = TextEditingController();

  final List<Restaurant> _items = [
    Restaurant(
      name: 'Cheese Burger',
      rating: '4.8',
      distance: '2 km',
      isOpen: true,
      images: [
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
      ],
      price: 199,
      category: 'Burgers',
      ingredients: ["Cheese", "Tomato", "Onion", "Lettuce", "Burger Sauce"],
      description:
          "Juicy grilled cheese burger with crispy lettuce and creamy burger sauce.",
      deliveryTime: "25 mins",
      offer: "50% OFF up to ₹100",
    ),
    Restaurant(
      name: 'Pepperoni Pizza',
      rating: '4.6',
      distance: '1 km',
      isOpen: true,
      images: [
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
      ],
      price: 299,
      category: 'Pizza',
      ingredients: ["Pepperoni", "Mozzarella", "Tomato Sauce", "Olives"],
      description:
          "Classic pepperoni pizza loaded with rich mozzarella cheese.",
      deliveryTime: "30 mins",
      offer: "Free Coke on orders above ₹499",
    ),
    Restaurant(
      name: 'Margherita Pizza',
      rating: '4.9',
      distance: '2 km',
      isOpen: true,
      images: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmomF1DksRYo9MLTC6zi2qx1XjX7R5PSqPYQ&s',
      ],
      price: 399,
      category: 'Pizza',
      ingredients: ["Fresh Basil", "Mozzarella", "Tomato", "Olive Oil"],
      description:
          "Fresh margherita pizza topped with basil and creamy mozzarella.",
      deliveryTime: "28 mins",
      offer: "Flat ₹75 OFF on first order",
    ),
    Restaurant(
      name: 'Sushi Set',
      rating: '4.9',
      distance: '4 km',
      isOpen: true,
      images: [
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800',
      ],
      price: 499,
      category: 'Sushi',
      ingredients: ["Rice", "Salmon", "Seaweed", "Soy Sauce"],
      description:
          "Premium sushi platter with authentic Japanese taste and fresh salmon.",
      deliveryTime: "35 mins",
      offer: "20% OFF on sushi combo",
    ),
    Restaurant(
      name: 'Classic Beef Burger',
      rating: '4.8',
      distance: '1.9 km',
      isOpen: true,
      images: [
        'https://assets.tmecosys.com/image/upload/t_web_rdp_recipe_584x480/img/recipe/ras/Assets/102cf51c-9220-4278-8b63-2b9611ad275e/Derivates/3831dbe2-352e-4409-a2e2-fc87d11cab0a.jpg',
      ],
      price: 200,
      category: 'Burgers',
      ingredients: ["Beef Patty", "Cheddar Cheese", "Onion", "Lettuce"],
      description:
          "Tender beef burger with smoky grilled flavors and soft buns.",
      deliveryTime: "22 mins",
      offer: "Buy 1 Get 1 Free",
    ),
    Restaurant(
      name: 'Greek Salad',
      rating: '4.7',
      distance: '2 km',
      isOpen: true,
      images: [
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      ],
      price: 220,
      category: 'Salads',
      ingredients: ["Cucumber", "Tomato", "Olives", "Feta Cheese"],
      description:
          "Healthy greek salad packed with crunchy vegetables and feta cheese.",
      deliveryTime: "18 mins",
      offer: "Healthy combo at ₹299",
    ),
    Restaurant(
      name: 'Chocolate Cake',
      rating: '4.9',
      distance: '1 km',
      isOpen: true,
      images: [
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
      ],
      price: 250,
      category: 'Desserts',
      ingredients: ["Chocolate", "Cream", "Cocoa", "Milk"],
      description:
          "Soft chocolate cake layered with creamy frosting and cocoa flavor.",
      deliveryTime: "20 mins",
      offer: "Free dessert on orders above ₹599",
    ),
    Restaurant(
      name: 'Ice Cream',
      rating: '4.6',
      distance: '2.5 km',
      isOpen: true,
      images: [
        'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800',
      ],
      price: 120,
      category: 'Desserts',
      ingredients: ["Milk", "Cream", "Vanilla", "Chocolate Syrup"],
      description:
          "Creamy and chilled ice cream with delicious sweet toppings.",
      deliveryTime: "15 mins",
      offer: "Buy 2 Scoops Get 1 Free",
    ),
    Restaurant(
      name: 'Turkey Burger',
      rating: '5.0',
      distance: '2.2 km',
      isOpen: true,
      images: [
        'https://hips.hearstapps.com/hmg-prod/images/turkey-burger-index-64873e8770b34.jpg?crop=0.8888888888888888xw:1xh;center,top&resize=1200:*',
      ],
      price: 299,
      category: 'Burgers',
      ingredients: ["Turkey Patty", "Tomato", "Lettuce", "Cheese"],
      description:
          "Healthy turkey burger with juicy meat and fresh vegetables.",
      deliveryTime: "24 mins",
      offer: "Free fries with burger combo",
    ),
    Restaurant(
      name: 'Veggie Bowl',
      rating: '4.3',
      distance: '3 km',
      isOpen: false,
      images: [
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
      ],
      price: 200,
      category: 'Salads',
      ingredients: ["Broccoli", "Corn", "Rice", "Carrot"],
      description:
          "Healthy veggie bowl loaded with fresh vegetables and herbs.",
      deliveryTime: "20 mins",
      offer: "20% OFF on healthy meals",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final int crossAxisCount = isDesktop
        ? 4
        : isTablet
            ? 3
            : 2;

    final double hPad = isDesktop
        ? screenWidth * 0.06
        : isTablet
            ? screenWidth * 0.03
            : 16.0;

    final double bannerHeight = isDesktop
        ? 260.0
        : isTablet
            ? 220.0
            : 180.0;

    final double locationTitleSize = isDesktop
        ? 22.0
        : isTablet
            ? 20.0
            : 18.0;

    final double locationSubSize = isDesktop
        ? 15.0
        : isTablet
            ? 14.0
            : 13.0;

    final double headerIconSize = isDesktop
        ? 32.0
        : isTablet
            ? 30.0
            : 28.0;

    final double actionIconPad = isDesktop || isTablet ? 12.0 : 10.0;

    final double cardAspectRatio = isDesktop
        ? 0.72
        : isTablet
            ? 0.70
            : 0.68;

    final displayList = _items
        .where(
          (r) => r.name.toLowerCase().contains(_searchText.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: isTablet || isDesktop ? 16 : 14,
              ),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.orange,
                        size: headerIconSize,
                      ),
                      SizedBox(width: isTablet || isDesktop ? 10 : 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Home",
                              style: TextStyle(
                                fontSize: locationTitleSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             SizedBox(height: 2),
                            Text(
                              "Calicut, Kerala",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: locationSubSize,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notification button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NotificationPage(),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(actionIconPad),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_none,
                                color: Colors.orange,
                                size: isTablet || isDesktop ? 26 : 22,
                              ),
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration:  BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: isTablet || isDesktop ? 14 : 12),

                      // Profile button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfilePage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(actionIconPad),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.orange,
                            size: isTablet || isDesktop ? 26 : 22,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isTablet || isDesktop ? 20 : 18),
                  FoodSearchBar(
                    controller: _searchController,
                    isSearching: isSearching,
                    onSearchTap: () {
                      setState(() => isSearching = true);
                    },
                    onSearchChanged: (value) {
                      setState(() => _searchText = value);
                    },
                    onClear: () {
                      setState(() {
                        _searchController.clear();
                        _searchText = "";
                        isSearching = false;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: isTablet || isDesktop ? 16 : 12),
            SizedBox(
              height: bannerHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: AutoBannerSlider(),
              ),
            ),

            SizedBox(height: isTablet || isDesktop ? 14 : 10),

            // ── Grid ─────────────────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: hPad,
                  vertical: 12,
                ),
                itemCount: displayList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: isTablet || isDesktop ? 16 : 12,
                  mainAxisSpacing: isTablet || isDesktop ? 16 : 12,
                  childAspectRatio: cardAspectRatio,
                ),
                itemBuilder: (context, index) {
                  return RestaurantCard(restaurant: displayList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}