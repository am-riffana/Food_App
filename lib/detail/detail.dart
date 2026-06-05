import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:foodapp/widgets/resturant_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailsPage extends StatefulWidget {
  final Restaurant restaurant;

  const DetailsPage({super.key, required this.restaurant});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Box ordersBox;
  int qty = 1;

  @override
  void initState() {
    super.initState();
    ordersBox = Hive.box('orders');
  }
  void addToCart() {
    ordersBox.add({
      "name": widget.restaurant.name,
      "image":
          widget.restaurant.images.isNotEmpty
              ? widget.restaurant.images.first
              : '',
      "price": widget.restaurant.price,
      "qty": qty,
      "status": "cart",
      "addedTime": DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("${widget.restaurant.name} added to cart 🛒"),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final String image =
        widget.restaurant.images.isNotEmpty
            ? widget.restaurant.images.first
            : 'https://via.placeholder.com/300';

    final double hPad =
        isDesktop
            ? screenWidth * 0.15
            : isTablet
            ? screenWidth * 0.06
            : 16.0;

    final double heroHeight =
        isDesktop
            ? 420.0
            : isTablet
            ? 370.0
            : 320.0;

    final double titleSize =
        isDesktop
            ? 34.0
            : isTablet
            ? 31.0
            : 28.0;

    final double sectionTitleSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 22.0
            : 20.0;

    final double bodyTextSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 15.0
            : 14.0;

    final double offerTitleSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;

    final double bottomBarPad =
        isDesktop
            ? 20.0
            : isTablet
            ? 18.0
            : 16.0;

    final double btnFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;

    final double btnVertPad =
        isDesktop
            ? 20.0
            : isTablet
            ? 18.0
            : 16.0;

    final double qtyFontSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 19.0
            : 18.0;

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: bottomBarPad),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet || isDesktop ? 16 : 12,
                vertical: isTablet || isDesktop ? 10 : 6,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (qty > 1) setState(() => qty--);
                    },
                    child: Icon(
                      Icons.remove,
                      size: isTablet || isDesktop ? 22 : 20,
                    ),
                  ),
                  SizedBox(width: isTablet || isDesktop ? 16 : 12),
                  Text(
                    "$qty",
                    style: TextStyle(
                      fontSize: qtyFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: isTablet || isDesktop ? 16 : 12),
                  GestureDetector(
                    onTap: () => setState(() => qty++),
                    child: Icon(
                      Icons.add,
                      size: isTablet || isDesktop ? 22 : 20,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: isTablet || isDesktop ? 18 : 14),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: btnVertPad),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: addToCart,
                child: Text(
                  "Add Item • ₹${widget.restaurant.price * qty}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: btnFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: heroHeight,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(image, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 16 : 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet || isDesktop ? 12 : 10,
                          vertical: isTablet || isDesktop ? 8 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: isTablet || isDesktop ? 18 : 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.restaurant.rating,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: bodyTextSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.restaurant.distance,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: bodyTextSize,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet || isDesktop ? 12 : 10,
                          vertical: isTablet || isDesktop ? 7 : 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              widget.restaurant.isOpen
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.restaurant.isOpen ? "OPEN" : "CLOSED",
                          style: TextStyle(
                            color:
                                widget.restaurant.isOpen
                                    ? Colors.green
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: bodyTextSize,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isTablet || isDesktop ? 28 : 22),
                  Container(
                    padding: EdgeInsets.all(isTablet || isDesktop ? 20 : 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: Colors.orange,
                          size: isTablet || isDesktop ? 34 : 30,
                        ),
                        SizedBox(width: isTablet || isDesktop ? 16 : 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.restaurant.offer,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: offerTitleSize,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Limited time offer",
                                style: TextStyle(fontSize: bodyTextSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 30 : 24),
                  Text(
                    "About Item",
                    style: TextStyle(
                      fontSize: sectionTitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isTablet || isDesktop ? 12 : 10),
                  Text(
                    widget.restaurant.description,
                    style: TextStyle(
                      height: 1.6,
                      color: Colors.grey,
                      fontSize: bodyTextSize,
                    ),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 30 : 24),

                  Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: sectionTitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isTablet || isDesktop ? 18 : 14),
                  Wrap(
                    spacing: isTablet || isDesktop ? 12 : 10,
                    runSpacing: isTablet || isDesktop ? 12 : 10,
                    children:
                        widget.restaurant.ingredients
                            .map((i) => _ingredientChip(i, isTablet, isDesktop))
                            .toList(),
                  ),

                  SizedBox(height: isTablet || isDesktop ? 30 : 24),

                  Container(
                    padding: EdgeInsets.all(isTablet || isDesktop ? 20 : 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.orange,
                              size: isTablet || isDesktop ? 24 : 22,
                            ),
                            SizedBox(width: isTablet || isDesktop ? 12 : 10),
                            Text(
                              "Delivery in ${widget.restaurant.deliveryTime}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: bodyTextSize,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet || isDesktop ? 18 : 14),
                        Row(
                          children: [
                            Icon(
                              Icons.delivery_dining,
                              color: Colors.orange,
                              size: isTablet || isDesktop ? 24 : 22,
                            ),
                            SizedBox(width: isTablet || isDesktop ? 12 : 10),
                            Text(
                              "Free delivery on orders above ₹199",
                              style: TextStyle(fontSize: bodyTextSize),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ingredientChip(String text, bool isTablet, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet || isDesktop ? 18 : 14,
        vertical: isTablet || isDesktop ? 12 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize:
              isDesktop
                  ? 15
                  : isTablet
                  ? 14
                  : 13,
        ),
      ),
    );
  }
}
