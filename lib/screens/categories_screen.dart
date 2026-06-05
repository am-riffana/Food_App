import 'package:flutter/material.dart';
import 'package:foodapp/screens/cart_screen.dart';
import 'package:foodapp/widgets/filter.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Box ordersBox;

  List<Map<String, dynamic>> allFoods = [];
  List<Map<String, dynamic>> dbCategories = []; // ← added
List<Map<String, dynamic>> localFoods = [
  {
    "name": "Chicken Biryani",
    "category": "Biryani",
    "description": "Aromatic chicken biryani",
    "price": 220,
    "rating": 4.8,
    "time": "30 min",
    "distance": "1.2 km",
    "delivery": "Fast Delivery",
    "image_url": "https://paragonrestaurant.in/wp-content/uploads/2022/10/Chicken-Biriyani.webp",
  },
  {
    "name": "Beef Biryani",
    "category": "Biryani",
    "description": "Spicy beef biryani",
    "price": 240,
    "rating": 4.7,
    "time": "35 min",
    "distance": "1.5 km",
    "delivery": "Fast Delivery",
    "image_url": "https://paragonrestaurant.in/wp-content/uploads/2022/10/mutton-biriyani-1.webp",
  },
  {
    "name": "Al Faham Chicken",
    "category": "Arabic",
    "description": "Grilled Arabic chicken",
    "price": 280,
    "rating": 4.9,
    "time": "25 min",
    "distance": "0.9 km",
    "delivery": "Fast Delivery",
    "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Al-faham%2C_Ceylon_Bake_house%2C_Marine_drive_Kochi%2C_Kerala.jpg/1280px-Al-faham%2C_Ceylon_Bake_house%2C_Marine_drive_Kochi%2C_Kerala.jpg?_=20210401060525",
  },
  {
    "name": "Shawarma Roll",
    "category": "Arabic",
    "description": "Chicken shawarma with garlic sauce",
    "price": 140,
    "rating": 4.6,
    "time": "15 min",
    "distance": "0.7 km",
    "delivery": "Fast Delivery",
    "image_url": "https://www.preciouscore.com/wp-content/uploads/2024/05/Beef-Shawarma-Wrap.jpg",
  },
  {
    "name": "Zinger Burger",
    "category": "Burger",
    "description": "Crispy chicken burger",
    "price": 180,
    "rating": 4.8,
    "time": "20 min",
    "distance": "1.1 km",
    "delivery": "Fast Delivery",
    "image_url": "https://5.imimg.com/data5/FX/TE/GLADMIN-40426501/chicken-zinger-1000x1000.png",
  },
  {
    "name": "Beef Burger",
    "category": "Burger",
    "description": "Juicy beef burger",
    "price": 210,
    "rating": 4.7,
    "time": "20 min",
    "distance": "1.4 km",
    "delivery": "Fast Delivery",
    "image_url": "https://www.puregoldpineapples.com.au/wp-content/uploads/2020/10/aussie-beef-burger.jpg",
  },
 
  {
    "name": "Chicken Fried Rice",
    "category": "Chinese",
    "description": "Fried rice with chicken",
    "price": 170,
    "rating": 4.5,
    "time": "20 min",
    "distance": "1.3 km",
    "delivery": "Fast Delivery",
    "image_url": "https://www.averiecooks.com/wp-content/uploads/2025/03/chickenfriedrice-9.jpg",
  },
  {
    "name": "Chicken Noodles",
    "category": "Chinese",
    "description": "Chinese style noodles",
    "price": 160,
    "rating": 4.4,
    "time": "20 min",
    "distance": "1.4 km",
    "delivery": "Fast Delivery",
    "image_url": "https://simplehomeedit.com/wp-content/uploads/2025/02/Three-Cup-Chicken-Noodles-4.webp",
  },
  {
    "name": "Masala Dosa",
    "category": "South Indian",
    "description": "Crispy dosa with potato filling",
    "price": 90,
    "rating": 4.8,
    "time": "15 min",
    "distance": "0.8 km",
    "delivery": "Fast Delivery",
    "image_url": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh3AVwip9rW-sRVS6ZzcoDu-pcF8Oe7pQL91hXuzB3iVDeuQpYGGQ02UDAx4s3-obYGDVZ_MtHkfnF6VMNe1SRl8GZqFIni4uUdb8ce-B2lHzxI4NflOHufuIUUXhNS6VA_Jgik-Tq5ZH2okHZ49dQ7CsPSveWRE92zo2xQsyqPuAU5mGNOTaQSQv4MEx_c/s320/1000446904.png",
  },
  {
    "name": "Idli Sambar",
    "category": "South Indian",
    "description": "Soft idli with sambar",
    "price": 70,
    "rating": 4.7,
    "time": "10 min",
    "distance": "0.5 km",
    "delivery": "Fast Delivery",
    "image_url": "https://vaya.in/recipes/wp-content/uploads/2018/02/Idli-and-Sambar-1.jpg",
  },
  {
    "name": "Chocolate Cake",
    "category": "Desserts",
    "description": "Rich chocolate cake",
    "price": 120,
    "rating": 4.9,
    "time": "10 min",
    "distance": "0.6 km",
    "delivery": "Fast Delivery",
    "image_url": "https://www.crazyforcrust.com/wp-content/uploads/2025/07/chocolate-poke-cake-3.jpg",
  },
  {
    "name": "Brownie",
    "category": "Desserts",
    "description": "Chocolate brownie",
    "price": 80,
    "rating": 4.8,
    "time": "8 min",
    "distance": "0.4 km",
    "delivery": "Fast Delivery",
    "image_url": "https://icecreambakery.in/wp-content/uploads/2024/12/Brownie-Recipe-with-Cocoa-Powder.jpg",
  },
  {
    "name": "Vanilla Ice Cream",
    "category": "Ice Cream",
    "description": "Creamy vanilla ice cream",
    "price": 60,
    "rating": 4.7,
    "time": "5 min",
    "distance": "0.3 km",
    "delivery": "Fast Delivery",
    "image_url": "https://www.katysfoodfinds.com/wp-content/uploads/2023/01/vanilla-bean-ice-cream-21.jpg",
  },
  {
    "name": "Mango Shake",
    "category": "Shakes",
    "description": "Fresh mango shake",
    "price": 90,
    "rating": 4.6,
    "time": "5 min",
    "distance": "0.5 km",
    "delivery": "Fast Delivery",
    "image_url": "https://www.sharmispassions.com/wp-content/uploads/2022/05/mango-milkshake1.jpg",
  },
  {
    "name": "Club Sandwich",
    "category": "Sandwich",
    "description": "Chicken club sandwich",
    "price": 130,
    "rating": 4.5,
    "time": "15 min",
    "distance": "0.8 km",
    "delivery": "Fast Delivery",
    "image_url": "https://ichef.bbci.co.uk/food/ic/food_16x9_1600/recipes/club_sandwich_16496_16x9.jpg",
  },
  {
    "name": "Grilled Chicken",
    "category": "BBQ",
    "description": "Smoky grilled chicken",
    "price": 260,
    "rating": 4.8,
    "time": "30 min",
    "distance": "1.7 km",
    "delivery": "Fast Delivery",
    "image_url": "https://www.budgetbytes.com/wp-content/uploads/2024/06/Grilled-Chicken-V1.jpeg",
  },
];

  // ── Hardcoded fallback categories ─────────────────────────────────────
List<String> categories = [
  'All',
  'Biryani',
  'Arabic',
  'Burger',
  'Pizza',
  'Chinese',
  'South Indian',
  'Desserts',
  'Ice Cream',
  'Shakes',
  'Sandwich',
  'BBQ',
];

String selectedCategory = 'All';
String selectedFilter = 'All';
bool isLoading = true;

@override
void initState() {
  super.initState();
  ordersBox = Hive.box('orders');
  initData();
}

Future<void> initData() async {
  await loadCategories();
  await loadFoods();
}

// ── Load categories from Supabase ─────────────────────────
Future<void> loadCategories() async {
  try {
    final data = await Supabase.instance.client
        .from('categories')
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: true);

    print("Categories from DB:");
    print(data);

    final List<String> fromDB = (data as List)
        .map((c) => c['name'].toString())
        .toList();

    setState(() {
      dbCategories = List<Map<String, dynamic>>.from(data);

      for (var category in fromDB) {
        if (!categories.contains(category)) {
          categories.add(category);
        }
      }
    });

    print("Categories shown in app:");
    print(categories);
  } catch (e) {
    debugPrint('Load categories error: $e');
  }
}

// ── Load foods from Supabase ─────────────────────────────
Future<void> loadFoods() async {
  setState(() => isLoading = true);

  try {
    final data = await Supabase.instance.client
        .from('foods')
        .select()
        .eq('is_available', true);

    final supabaseFoods =
        List<Map<String, dynamic>>.from(data);

    setState(() {
      for (var food in supabaseFoods) {
        final category = food['category'];

        if (category != null &&
            !categories.contains(category.toString())) {
          categories.add(category.toString());
        }
      }

      allFoods = [...localFoods, ...supabaseFoods];
      isLoading = false;
    });
  } catch (e) {
    debugPrint('Food load error: $e');

    setState(() {
      allFoods = localFoods;
      isLoading = false;
    });
  }
}

// ── Filter Foods ─────────────────────────────────────────
List<Map<String, dynamic>> get filteredFoods {
  List<Map<String, dynamic>> list = List.from(allFoods);

  if (selectedCategory != 'All') {
    list = list
        .where((f) => f['category'] == selectedCategory)
        .toList();
  }

  switch (selectedFilter) {
    case 'Low Price':
      list.sort(
        (a, b) =>
            (a['price'] as num).compareTo(b['price'] as num),
      );
      break;

    case 'High Rating':
      list.sort(
        (a, b) =>
            (b['rating'] as num).compareTo(a['rating'] as num),
      );
      break;

    case 'Fast Delivery':
      list = list
          .where(
            (f) => f['delivery'] == 'Fast Delivery',
          )
          .toList();
      break;

    case 'Nearest':
      list.sort((a, b) {
        final aD = double.tryParse(
              a['distance']
                      ?.toString()
                      .replaceAll(' km', '') ??
                  '99',
            ) ??
            99;

        final bD = double.tryParse(
              b['distance']
                      ?.toString()
                      .replaceAll(' km', '') ??
                  '99',
            ) ??
            99;

        return aD.compareTo(bD);
      });
      break;
  }

  return list;
}

  void addToCart(Map<String, dynamic> item) {
    final data = {
      "name": item["name"],
      "price": item["price"],
      "image": item["image_url"] ?? "",
      "qty": 1,
    };

    int index = ordersBox.values
        .toList()
        .indexWhere((e) => e['name'] == item['name']);

    if (index != -1) {
      final existing =
          Map<String, dynamic>.from(ordersBox.getAt(index));
      existing['qty'] = (existing['qty'] ?? 1) + 1;
      ordersBox.putAt(index, existing);
    } else {
      ordersBox.add(data);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['name']} added to cart"),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: "View Cart",
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double hPad = isDesktop
        ? screenWidth * 0.06
        : isTablet
            ? screenWidth * 0.04
            : 16.0;

    final double headerFontSize = isDesktop
        ? 30.0
        : isTablet
            ? 28.0
            : 26.0;

    final double chipBarHeight = isDesktop
        ? 64.0
        : isTablet
            ? 60.0
            : 55.0;

    final bool useGrid = isTablet || isDesktop;
    final int gridColumns = isDesktop ? 3 : 2;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header ─────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: headerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FilterPage(
                              selectedFilter: selectedFilter),
                        ),
                      );
                      if (result != null) {
                        setState(() => selectedFilter = result);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet || isDesktop ? 20 : 16,
                        vertical: isTablet || isDesktop ? 12 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: selectedFilter != 'All'
                            ? Colors.orange
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: selectedFilter != 'All'
                                ? Colors.white
                                : Colors.orange,
                            size: isTablet || isDesktop ? 22 : 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            selectedFilter == 'All'
                                ? "Filter"
                                : selectedFilter,
                            style: TextStyle(
                              color: selectedFilter != 'All'
                                  ? Colors.white
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  isTablet || isDesktop ? 15 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Category Chips ──────────────────────────────────────────
            Container(
              color: Colors.white,
              height: chipBarHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                    horizontal: hPad, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  final isSelected = selectedCategory == cat;

                  // ── Show category image if available ────────────────
                  final catData = dbCategories.firstWhere(
                    (c) => c['name'] == cat,
                    orElse: () => {},
                  );
                  final String? catImage =
                      catData['image_url']?.toString();

                  return GestureDetector(
                    onTap: () =>
                        setState(() => selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet || isDesktop ? 16 : 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.orange
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Category image thumbnail ────────────────
                          if (catImage != null &&
                              catImage.isNotEmpty &&
                              cat != 'All')
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 6),
                              child: ClipOval(
                                child: Image.network(
                                  catImage,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          Text(
                            cat,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  isTablet || isDesktop ? 15 : 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 6),

            // ── Food List / Grid ────────────────────────────────────────
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: Colors.orange),
                    )
                  : filteredFoods.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fastfood_outlined,
                                  size:
                                      isTablet || isDesktop ? 80 : 60,
                                  color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text(
                                "No items in this category",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      isTablet || isDesktop ? 18 : 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : useGrid
                          ? GridView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: hPad,
                                vertical: 14,
                              ),
                              itemCount: filteredFoods.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridColumns,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio:
                                    isDesktop ? 0.72 : 0.68,
                              ),
                              itemBuilder: (_, i) => _foodCard(
                                  filteredFoods[i],
                                  isGrid: true),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(14),
                              itemCount: filteredFoods.length,
                              itemBuilder: (_, i) => _foodCard(
                                  filteredFoods[i],
                                  isGrid: false),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodCard(Map<String, dynamic> food,
      {bool isGrid = false}) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final imageUrl = food['image_url'] ?? '';

    final double imageHeight = isGrid
        ? (isDesktop ? 160.0 : 140.0)
        : (isDesktop
            ? 260.0
            : isTablet
                ? 230.0
                : 210.0);

    final double nameFontSize = isDesktop
        ? 18.0
        : isTablet
            ? 17.0
            : (isGrid ? 15.0 : 20.0);

    final double descFontSize = isDesktop
        ? 13.0
        : isTablet
            ? 12.0
            : 13.0;

    final double priceFontSize = isGrid
        ? (isDesktop ? 18.0 : 16.0)
        : (isDesktop
            ? 28.0
            : isTablet
                ? 26.0
                : 26.0);

    return Container(
      margin: EdgeInsets.only(bottom: isGrid ? 0 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
                child: Image.network(
                  imageUrl,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: imageHeight,
                    color: Colors.orange.shade50,
                    child: const Icon(Icons.fastfood,
                        color: Colors.orange, size: 60),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    food['category'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(isGrid ? 10 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        food['name'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: nameFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            food['rating'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isGrid ? 4 : 8),
                if (!isGrid || isTablet || isDesktop)
                  Text(
                    food['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: descFontSize,
                    ),
                  ),
                SizedBox(height: isGrid ? 6 : 12),
                if (!isGrid || isDesktop)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.orange),
                        const SizedBox(width: 3),
                        Text(food['distance'] ?? '',
                            style:
                                TextStyle(fontSize: descFontSize)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.orange),
                        const SizedBox(width: 3),
                        Text(food['time'] ?? '',
                            style:
                                TextStyle(fontSize: descFontSize)),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Text(
                      "₹${food['price']}",
                      style: TextStyle(
                        fontSize: priceFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(
                          horizontal: isGrid ? 10 : 18,
                          vertical: isGrid ? 8 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => addToCart(food),
                      icon: Icon(Icons.add_shopping_cart,
                          color: Colors.white,
                          size: isGrid ? 14 : 18),
                      label: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isGrid ? 12 : 14,
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