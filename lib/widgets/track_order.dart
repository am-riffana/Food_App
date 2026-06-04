import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foodapp/widgets/responsive.dart';
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
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  late Timer timer;
  int remainingMinutes = 25;

  final LatLng restaurantLocation = LatLng(11.2588, 75.7804);
  final LatLng userLocation = LatLng(11.3000, 75.8200);

  @override
  void initState() {
    super.initState();
    updateTime();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTime());
  }

  void updateTime() {
    final ordered = DateTime.parse(widget.orderedTime);
    final delivery = ordered.add(const Duration(minutes: 25));
    final diff = delivery.difference(DateTime.now());
    setState(() => remainingMinutes = diff.inMinutes);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final bool delivered = remainingMinutes <= 0;

    // On desktop, use side-by-side layout (map left, details right)
    final bool useSideBySide = isDesktop;

    // Horizontal padding for detail panel
    final double hPad = isDesktop
        ? 28.0
        : isTablet
            ? 24.0
            : 20.0;

    // Food image size
    final double imgSize = isDesktop
        ? 110.0
        : isTablet
            ? 100.0
            : 90.0;

    // Font sizes
    final double etaFontSize = isDesktop
        ? 34.0
        : isTablet
            ? 32.0
            : 30.0;

    final double etaSubSize = isDesktop
        ? 18.0
        : isTablet
            ? 17.0
            : 16.0;

    final double itemNameSize = isDesktop
        ? 22.0
        : isTablet
            ? 21.0
            : 20.0;

    final double trackTitleSize = isDesktop
        ? 19.0
        : isTablet
            ? 18.0
            : 17.0;

    final double trackSubSize = isDesktop
        ? 15.0
        : isTablet
            ? 14.0
            : 13.0;

    // Delivery icon in map overlay
    final double deliveryIconSize = isDesktop
        ? 60.0
        : isTablet
            ? 55.0
            : 50.0;

    // Map panel
    Widget mapPanel = Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: restaurantLocation,
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.foodapp',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [restaurantLocation, userLocation],
                  strokeWidth: 5,
                  color: Colors.orange,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: restaurantLocation,
                  width: 80,
                  height: 80,
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                Marker(
                  point: userLocation,
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

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
        ),

        // Back + LIVE badge
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet || isDesktop ? 18 : 14,
              vertical: isTablet || isDesktop ? 14 : 10,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: isTablet || isDesktop ? 24 : 20,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    iconSize: isTablet || isDesktop ? 22 : 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet || isDesktop ? 16 : 14,
                    vertical: isTablet || isDesktop ? 10 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet || isDesktop ? 14 : 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Delivery partner badge in map center
        Positioned(
          top: isTablet || isDesktop ? 200 : 180,
          left: isDesktop
              ? screenWidth * 0.04
              : isTablet
                  ? 80
                  : 120,
          right: isDesktop
              ? screenWidth * 0.04
              : isTablet
                  ? 80
                  : 120,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet || isDesktop ? 22 : 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                child: Icon(
                  Icons.delivery_dining,
                  size: deliveryIconSize,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Delivery Partner Nearby",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet || isDesktop ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // Detail panel
    Widget detailPanel = Container(
      width: double.infinity,
      padding: EdgeInsets.all(hPad),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: useSideBySide
            ? BorderRadius.zero
            : const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34),
              ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ETA
            Text(
              delivered ? "Order Delivered 🎉" : "$remainingMinutes mins away",
              style: TextStyle(
                fontSize: etaFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet || isDesktop ? 10 : 8),
            Text(
              delivered ? "Enjoy your meal ❤️" : "Your order is on the way",
              style: TextStyle(color: Colors.grey, fontSize: etaSubSize),
            ),

            SizedBox(height: isTablet || isDesktop ? 28 : 24),

            // Food item card
            Container(
              padding: EdgeInsets.all(isTablet || isDesktop ? 16 : 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      widget.image,
                      height: imgSize,
                      width: imgSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: isTablet || isDesktop ? 18 : 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemName,
                          style: TextStyle(
                            fontSize: itemNameSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isTablet || isDesktop ? 10 : 8),
                        Text(
                          "Preparing with love ❤️",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: etaSubSize - 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isTablet || isDesktop ? 32 : 28),

            // Tracking steps
            _trackingTile(
              icon: Icons.check_circle,
              title: "Order Confirmed",
              subtitle: "Restaurant accepted your order",
              done: true,
              titleSize: trackTitleSize,
              subSize: trackSubSize,
              isLarge: isTablet || isDesktop,
            ),
            _trackingTile(
              icon: Icons.restaurant,
              title: "Food Prepared",
              subtitle: "Chef prepared your food",
              done: true,
              titleSize: trackTitleSize,
              subSize: trackSubSize,
              isLarge: isTablet || isDesktop,
            ),
            _trackingTile(
              icon: Icons.delivery_dining,
              title: "On The Way",
              subtitle: delivered
                  ? "Delivered successfully"
                  : "Rider is heading to you",
              done: true,
              titleSize: trackTitleSize,
              subSize: trackSubSize,
              isLarge: isTablet || isDesktop,
            ),
            _trackingTile(
              icon: Icons.home,
              title: "Delivered",
              subtitle: delivered ? "Enjoy your food 🍔" : "Waiting for delivery",
              done: delivered,
              titleSize: trackTitleSize,
              subSize: trackSubSize,
              isLarge: isTablet || isDesktop,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: useSideBySide
          // ── Desktop: map left | details right ──────────────────────
          ? Row(
              children: [
                Expanded(flex: 5, child: mapPanel),
                Container(width: 1, color: Colors.grey.shade200),
                SizedBox(
                  width: 420,
                  child: detailPanel,
                ),
              ],
            )
          // ── Mobile & Tablet: map top | details bottom ───────────────
          : Column(
              children: [
                Expanded(flex: 5, child: mapPanel),
                Expanded(flex: 6, child: detailPanel),
              ],
            ),
    );
  }

  Widget _trackingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool done,
    required double titleSize,
    required double subSize,
    required bool isLarge,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLarge ? 28 : 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isLarge ? 14 : 12),
            decoration: BoxDecoration(
              color: done ? Colors.green.shade100 : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: done ? Colors.green : Colors.grey,
              size: isLarge ? 24 : 22,
            ),
          ),
          SizedBox(width: isLarge ? 16 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isLarge ? 6 : 5),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey, fontSize: subSize),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}