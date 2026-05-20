import 'dart:async';

import 'package:flutter/material.dart';

class TrackOrderPage extends StatefulWidget {
  final String itemName;
  final String image;
  final String orderedTime;

  const TrackOrderPage({
    super.key,
    required this.itemName,
    required this.image,
    required this.orderedTime,
  });

  @override
  State<TrackOrderPage> createState() =>
      _TrackOrderPageState();
}

class _TrackOrderPageState
    extends State<TrackOrderPage> {
  late Timer timer;

  int remainingMinutes = 25;

  @override
  void initState() {
    super.initState();

    updateTime();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        updateTime();
      },
    );
  }

  void updateTime() {
    final ordered =
        DateTime.parse(widget.orderedTime);

    final delivery =
        ordered.add(
      const Duration(minutes: 25),
    );

    final diff =
        delivery.difference(
      DateTime.now(),
    );

    setState(() {
      remainingMinutes =
          diff.inMinutes;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delivered =
        remainingMinutes <= 0;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Track Order",
          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            /// FOOD CARD
            Container(
              padding:
                  const EdgeInsets.all(
                14,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  22,
                ),
              ),

              child: Row(
                children: [

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),

                    child: Image.network(
                      widget.image,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(
                          widget.itemName,

                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                            height: 8),

                        Text(
                          delivered
                              ? "Your order has arrived 🎉"
                              : "Arriving in $remainingMinutes mins",

                          style:
                              TextStyle(
                            color: delivered
                                ? Colors.green
                                : Colors.orange,

                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// SWIGGY STYLE MAP
            Container(
              height: 240,

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                image: const DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1200&auto=format&fit=crop",
                  ),

                  fit: BoxFit.cover,
                ),
              ),

              child: Stack(
                children: [

                  /// DARK OVERLAY
                  Container(
                    decoration:
                        BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),

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

                  /// CENTER DELIVERY ICON
                  Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [

                        Container(
                          padding:
                              const EdgeInsets.all(
                            18,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,
                            shape:
                                BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black26,
                                blurRadius:
                                    10,
                              ),
                            ],
                          ),

                          child: const Icon(
                            Icons
                                .delivery_dining,
                            size: 45,
                            color:
                                Colors.orange,
                          ),
                        ),

                        const SizedBox(
                            height: 14),

                        const Text(
                          "Delivery Partner is Near You",

                          style:
                              TextStyle(
                            color:
                                Colors.white,
                            fontSize:
                                18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// LIVE BADGE
                  Positioned(
                    top: 16,
                    right: 16,

                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.green,
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),

                      child: const Row(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          CircleAvatar(
                            radius: 4,
                            backgroundColor:
                                Colors.white,
                          ),

                          SizedBox(width: 8),

                          Text(
                            "LIVE",

                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// TRACKING STEPS
            Container(
              padding:
                  const EdgeInsets.all(
                18,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  22,
                ),
              ),

              child: Column(
                children: [

                  trackingTile(
                    icon:
                        Icons.receipt_long,
                    title:
                        "Order Confirmed",
                    subtitle:
                        "Restaurant accepted your order",
                    done: true,
                  ),

                  trackingTile(
                    icon:
                        Icons.restaurant,
                    title:
                        "Preparing Food",
                    subtitle:
                        "Chef is preparing your meal",
                    done: true,
                  ),

                  trackingTile(
                    icon: Icons
                        .delivery_dining,
                    title: "On The Way",
                    subtitle: delivered
                        ? "Order delivered successfully"
                        : "Delivery partner is coming",
                    done: true,
                  ),

                  trackingTile(
                    icon: Icons.home,
                    title: "Delivered",
                    subtitle: delivered
                        ? "Enjoy your food 🍔"
                        : "Waiting for delivery",
                    done: delivered,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// DELIVERY BOY CARD
            Container(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  22,
                ),
              ),

              child: Row(
                children: [

                  const CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(
                      "https://randomuser.me/api/portraits/men/32.jpg",
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(
                          "Rahul Kumar",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Delivery Partner",

                          style: TextStyle(
                            color:
                                Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  CircleAvatar(
                    backgroundColor:
                        Colors.orange
                            .shade50,

                    child: IconButton(
                      onPressed: () {},

                      icon: const Icon(
                        Icons.call,
                        color:
                            Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget trackingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool done,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 22,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            padding:
                const EdgeInsets.all(
              10,
            ),

            decoration: BoxDecoration(
              color: done
                  ? Colors.green
                      .shade100
                  : Colors.grey
                      .shade200,

              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: done
                  ? Colors.green
                  : Colors.grey,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 4),

                Text(
                  subtitle,

                  style:
                      const TextStyle(
                    color: Colors.grey,
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