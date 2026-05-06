import 'package:flutter/material.dart';
import 'package:foodapp/models/resturant_model.dart';
import 'package:foodapp/widgets/search.dart';
import 'package:foodapp/widgets/categories.dart';
import 'package:foodapp/widgets/slide_banner.dart';
import 'package:foodapp/widgets/big_resturant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _catIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  final _categories = [
    ('🍽️', 'All'),
    ('🍔', 'Burgers'),
    ('🍕', 'Pizza'),
    ('🍱', 'Sushi'),
    ('🥗', 'Salads'),
    ('🍰', 'Desserts'),
    
  ];

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
    ),

    Restaurant(
      name: 'margherita pizza',
      rating: '4.9',
      distance: '2km',
      isOpen: true,
      images: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmomF1DksRYo9MLTC6zi2qx1XjX7R5PSqPYQ&s',
      ],
      price: 399,
      category: 'Pizza',
    ),
     Restaurant(
      name: 'sicilian pizza',
      rating: '5.5',
      distance: '3.5km',
      isOpen: true,
      images: [
        'https://www.seriouseats.com/thmb/uWam_1G3L2QhYeARM_9W_OY6jD4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__images__2016__05__20160503-spicy-spring-pizza-recipe-37-2be36645b22a4ef3b3545bdb6ab2ad61.jpg',
      ],
      price: 329,
      category: 'Pizza',
    ),
     Restaurant(
      name: 'hawaiian pizza',
      rating: '4.9',
      distance: '1.5 km',
      isOpen: true,
      images: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSo0zdloorMSKb9nPMUAGY47xznZiWwSCH6Cw&s',
      ],
      price: 299,
      category: 'Pizza',
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
    ),
     Restaurant(
      name: 'Maki Sushi',
      rating: '5.9',
      distance: '6 km',
      isOpen: true,
      images: [
        'https://takestwoeggs.com/wp-content/uploads/2023/08/Tekka-Maki-Tuna-Sushi-Roll-Takestwoeggs-sq.jpg',
      ],
      price: 399,
      category: 'Sushi',
    ),
     Restaurant(
      name: 'Temaki Sushi',
      rating: '5.0',
      distance: '4.5 km',
      isOpen: true,
      images: [
        'https://www.worldofvegan.com/wp-content/uploads/2022/12/temaki-sushi-hand-rolls.jpg',
      ],
      price: 300,
      category: 'Sushi',
    ),
     Restaurant(
      name: 'Salmon Sashimi',
      rating: '5.0',
      distance: '2 km',
      isOpen: true,
      images: [
        'https://www.manusmenu.com/wp-content/uploads/2016/06/salmon-sashimi-served-with-ponzu-and-wasabi-500x375.webp',
      ],
      price: 600,
      category: 'Sushi',
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
    ),
    Restaurant(
      name: 'Turkey Burger', 
      rating: '5.0',
       distance: '2.2km', 
       isOpen: true, 
       images: [
      'https://hips.hearstapps.com/hmg-prod/images/turkey-burger-index-64873e8770b34.jpg?crop=0.8888888888888888xw:1xh;center,top&resize=1200:*',
    ], price: 299,
     category: 'Burgers'
     ),

      Restaurant(
      name: 'Veggie Burger', 
      rating: '4.5',
       distance: '3.5 km', 
       isOpen: false, 
       images: [
      'https://cdn.apartmenttherapy.info/image/upload/f_jpg,q_auto:eco,c_fill,g_auto,w_1500,ar_1:1/tk%2Fphoto%2F2025%2F06-2025%2F2025-06-veggie-burger%2Fveggie-burger-340',
    ], price: 305,
     category: 'Burgers'
     ),
     Restaurant(
  name: 'Caesar Salad',
  rating: '4.5',
  distance: '1.2 km',
  isOpen: true,
  images: [
    'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=800',
  ],
  price: 180,
  category: 'Salads',
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
),

Restaurant(
  name: 'Cupcake',
  rating: '4.4',
  distance: '1.8 km',
  isOpen: true,
  images: [
    'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?w=800',
  ],
  price: 90,
  category: 'Desserts',
),

    
  ];
@override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _categories[_catIndex].$2;

    final filtered = _items.where((r) {
      final matchCategory =
          selectedCategory == 'All' || r.category == selectedCategory;

      final matchSearch =
          r.name.toLowerCase().contains(_searchText.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();

    final displayList = filtered.isEmpty ? _items : filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      body: Column(
        children: [
          /// 🔍 SEARCH BAR
         FoodSearchBar(
  controller: _searchController,
  onSearchChanged: (value) {
    setState(() {
      _searchText = value;
    });
  },
),
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 160,
                  child: AutoBannerSlider(),
                ),

                const SizedBox(height: 10),

                CategorySection(
                  categories: _categories,
                  selectedIndex: _catIndex,
                  onTap: (i) => setState(() => _catIndex = i),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: GridView.builder(
                    padding:  EdgeInsets.all(12),
                    itemCount: displayList.length,
                    gridDelegate:
                         SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      return RestaurantCard(
                        restaurant: displayList[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}