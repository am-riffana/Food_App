import 'package:flutter/material.dart';
import 'package:foodapp/detail/detail.dart';
import 'package:foodapp/widgets/resturant_model.dart';
import 'package:foodapp/widgets/responsive.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.w(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 24 : width * 0.04),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isTablet ? 24 : width * 0.04),
                  ),

                  child:
                      restaurant.images.isEmpty
                          ? Center(child: Icon(Icons.image_not_supported))
                          : PageView.builder(
                            itemCount: restaurant.images.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                restaurant.images[index],
                                width: double.infinity,
                                fit: BoxFit.cover,

                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  }

                                  return Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                },

                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(Icons.broken_image),
                                  );
                                },
                              );
                            },
                          ),
                ),

                Positioned(
                  top: width * 0.02,
                  right: width * 0.02,

                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02,
                      vertical: width * 0.01,
                    ),

                    decoration: BoxDecoration(
                      color: restaurant.isOpen ? Colors.green : Colors.red,

                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    ),

                    child: Text(
                      restaurant.isOpen ? "Open" : "Closed",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 12 : width * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: width * 0.015,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 18 : width * 0.035,
                    ),
                  ),

                  SizedBox(height: width * 0.01),

                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: isTablet ? 18 : width * 0.035,
                        color: Colors.orange,
                      ),

                      SizedBox(width: width * 0.008),

                      Text(
                        restaurant.rating,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : width * 0.03,
                        ),
                      ),

                      SizedBox(width: width * 0.02),

                      Icon(
                        Icons.location_on,
                        size: isTablet ? 18 : width * 0.035,
                        color: Colors.red,
                      ),

                      SizedBox(width: width * 0.008),

                      Text(
                        restaurant.distance,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : width * 0.03,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: width * 0.01),

                  Text(
                    "₹${restaurant.price}",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 16 : width * 0.032,
                    ),
                  ),

                  Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 42 : width * 0.08,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.zero,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 10,
                          ),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(restaurant: restaurant),
                          ),
                        );
                      },

                      child: Text(
                        "View",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 15 : width * 0.03,
                        ),
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
  }
}
