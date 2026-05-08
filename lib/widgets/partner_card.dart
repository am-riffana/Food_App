import 'package:flutter/material.dart';
import 'package:foodapp/models/resturant_model.dart';

class PartnerCard extends StatelessWidget {
  final Restaurant restaurant;

  const PartnerCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final r = restaurant;

    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              r.images.isNotEmpty
                  ? r.images.first
                  : 'https://via.placeholder.com/150',
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name, style: TextStyle(fontWeight: FontWeight.w600)),

                SizedBox(height: 5),
                Text(
                  "₹${r.price}",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
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
