import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  /// RESTAURANT LOCATION
  final LatLng restaurantLocation =
      LatLng(11.2588, 75.7804);

  /// USER LOCATION
  final LatLng userLocation =
      LatLng(11.3000, 75.8200);

  @override
  void initState() {
    super.initState();

    updateTime();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateTime(),
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

      body: Column(
        children: [

          /// MAP SECTION
          Expanded(
            flex: 5,
            child: Stack(
              children: [

                /// OPEN STREET MAP
                FlutterMap(
                  options: MapOptions(
                    initialCenter:
                        restaurantLocation,
                    initialZoom: 13,
                  ),

                  children: [

                    /// MAP
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                      userAgentPackageName:
                          'com.example.foodapp',
                    ),

                    /// ROUTE LINE
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [
                            restaurantLocation,
                            userLocation,
                          ],

                          strokeWidth: 5,

                          color:
                              Colors.orange,
                        ),
                      ],
                    ),

                    /// MARKERS
                    MarkerLayer(
                      markers: [

                        /// RESTAURANT
                        Marker(
                          point:
                              restaurantLocation,

                          width: 80,
                          height: 80,

                          child: const Icon(
                            Icons.restaurant,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),

                        /// USER
                        Marker(
                          point:
                              userLocation,

                          width: 80,
                          height: 80,

                          child: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// DARK OVERLAY
                Container(
                  decoration:
                      BoxDecoration(
                    gradient:
                        LinearGradient(
                      begin:
                          Alignment.topCenter,
                      end:
                          Alignment.bottomCenter,
                      colors: [
                        Colors.black
                            .withOpacity(
                          0.1,
                        ),
                        Colors.black
                            .withOpacity(
                          0.4,
                        ),
                      ],
                    ),
                  ),
                ),

                /// TOP BAR
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),

                    child: Row(
                      children: [

                        /// BACK BUTTON
                        CircleAvatar(
                          backgroundColor:
                              Colors.white,

                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(
                                  context);
                            },

                            icon:
                                const Icon(
                              Icons.arrow_back,
                              color:
                                  Colors.black,
                            ),
                          ),
                        ),

                        const Spacer(),

                        /// LIVE BADGE
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                14,
                            vertical:
                                8,
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

                          child:
                              const Row(
                            children: [

                              CircleAvatar(
                                radius: 4,
                                backgroundColor:
                                    Colors.white,
                              ),

                              SizedBox(
                                  width: 8),

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
                      ],
                    ),
                  ),
                ),

                /// DELIVERY ICON
                Positioned(
                  top: 180,
                  left: 120,
                  right: 120,

                  child: Column(
                    children: [

                      Container(
                        padding:
                            const EdgeInsets.all(
                          20,
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

                              blurRadius: 10,
                            ),
                          ],
                        ),

                        child:
                            const Icon(
                          Icons
                              .delivery_dining,

                          size: 50,

                          color:
                              Colors.orange,
                        ),
                      ),

                      const SizedBox(
                          height: 12),

                      const Text(
                        "Delivery Partner Nearby",

                        style:
                            TextStyle(
                          color:
                              Colors.white,

                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// DETAILS SECTION
          Expanded(
            flex: 6,
            child: Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                20,
              ),

              decoration:
                  const BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.only(
                  topLeft:
                      Radius.circular(
                    34,
                  ),

                  topRight:
                      Radius.circular(
                    34,
                  ),
                ),
              ),

              child:
                  SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    /// ETA
                    Text(
                      delivered
                          ? "Order Delivered 🎉"
                          : "$remainingMinutes mins away",

                      style:
                          const TextStyle(
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 8),

                    Text(
                      delivered
                          ? "Enjoy your meal ❤️"
                          : "Your order is on the way",

                      style:
                          const TextStyle(
                        color:
                            Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                        height: 24),

                    /// FOOD CARD
                    Container(
                      padding:
                          const EdgeInsets.all(
                        14,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFFF8F8F8,
                        ),

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

                            child:
                                Image.network(
                              widget.image,

                              height: 90,
                              width: 90,

                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(
                              width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  widget
                                      .itemName,

                                  style:
                                      const TextStyle(
                                    fontSize:
                                        20,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                        8),

                                const Text(
                                  "Preparing with love ❤️",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height: 28),

                    /// TRACKING STEPS
                    trackingTile(
                      icon:
                          Icons.check_circle,

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
                          "Food Prepared",

                      subtitle:
                          "Chef prepared your food",

                      done: true,
                    ),

                    trackingTile(
                      icon: Icons
                          .delivery_dining,

                      title:
                          "On The Way",

                      subtitle:
                          delivered
                              ? "Delivered successfully"
                              : "Rider is heading to you",

                      done: true,
                    ),

                    trackingTile(
                      icon:
                          Icons.home,

                      title:
                          "Delivered",

                      subtitle:
                          delivered
                              ? "Enjoy your food 🍔"
                              : "Waiting for delivery",

                      done:
                          delivered,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        bottom: 24,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            padding:
                const EdgeInsets.all(
              12,
            ),

            decoration:
                BoxDecoration(
              color: done
                  ? Colors.green
                      .shade100
                  : Colors.grey
                      .shade200,

              shape:
                  BoxShape.circle,
            ),

            child: Icon(
              icon,

              color: done
                  ? Colors.green
                  : Colors.grey,
            ),
          ),

          const SizedBox(
              width: 14),

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
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 5),

                Text(
                  subtitle,

                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
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