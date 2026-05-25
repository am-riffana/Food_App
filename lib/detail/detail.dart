import 'package:flutter/material.dart';
import 'package:foodapp/widgets/resturant_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailsPage extends StatefulWidget {
  final Restaurant restaurant;

  const DetailsPage({
    super.key,
    required this.restaurant,
  });

  @override
  State<DetailsPage> createState() =>
      _DetailsPageState();
}

class _DetailsPageState
    extends State<DetailsPage> {
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
      "addedTime":
          DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "${widget.restaurant.name} added to cart 🛒",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image =
        widget.restaurant.images.isNotEmpty
            ? widget.restaurant.images.first
            : 'https://via.placeholder.com/300';

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
            ),
          ],
        ),

        child: Row(
          children: [
            /// QUANTITY
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orange,
                ),
                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (qty > 1) {
                        setState(() {
                          qty--;
                        });
                      }
                    },

                    child: const Icon(
                      Icons.remove,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    "$qty",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 12),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        qty++;
                      });
                    },

                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            /// ADD TO CART BUTTON
            Expanded(
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                onPressed: addToCart,

                child: Text(
                  "Add Item • ₹${widget.restaurant.price * qty}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: CustomScrollView(
        slivers: [
          /// APP BAR IMAGE
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,

            leading: Padding(
              padding: const EdgeInsets.all(8),

              child: CircleAvatar(
                backgroundColor:
                    Colors.white,

                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),

                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),

                  Container(
                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin:
                            Alignment.topCenter,
                        end: Alignment
                            .bottomCenter,
                        colors: [
                          Colors.black
                              .withOpacity(
                            0.2,
                          ),
                          Colors.black
                              .withOpacity(
                            0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// DETAILS
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    widget.restaurant.name,
                    style:
                        const TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// RATING
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),

                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color:
                                  Colors.white,
                              size: 16,
                            ),

                            const SizedBox(
                                width: 4),

                            Text(
                              widget
                                  .restaurant
                                  .rating,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          width: 12),

                      Text(
                        widget
                            .restaurant
                            .distance,

                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const SizedBox(
                          width: 12),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration:
                            BoxDecoration(
                          color: widget
                                  .restaurant
                                  .isOpen
                              ? Colors.green
                                  .shade50
                              : Colors.red
                                  .shade50,

                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                        ),

                        child: Text(
                          widget.restaurant
                                  .isOpen
                              ? "OPEN"
                              : "CLOSED",

                          style: TextStyle(
                            color: widget
                                    .restaurant
                                    .isOpen
                                ? Colors.green
                                : Colors.red,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  /// OFFER CARD
                  Container(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.orange.shade50,

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_offer,
                          color: Colors.orange,
                          size: 30,
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                widget.restaurant.offer,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              const Text(
                                "Limited time offer",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ABOUT
                  const Text(
                    "About Item",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.restaurant.description,
                    style: const TextStyle(
                      height: 1.6,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// INGREDIENTS
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        widget.restaurant.ingredients
                            .map(
                              (ingredient) =>
                                  ingredientChip(
                                ingredient,
                              ),
                            )
                            .toList(),
                  ),

                  const SizedBox(height: 24),

                  /// DELIVERY INFO
                  Container(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              color:
                                  Colors.orange,
                            ),

                            const SizedBox(width: 10),

                            Text(
                              "Delivery in ${widget.restaurant.deliveryTime}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        const Row(
                          children: [
                            Icon(
                              Icons.delivery_dining,
                              color:
                                  Colors.orange,
                            ),

                            SizedBox(width: 10),

                            Text(
                              "Free delivery on orders above ₹199",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ingredientChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius:
            BorderRadius.circular(30),
      ),

      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}