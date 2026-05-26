import 'package:flutter/material.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;

  final String subtitle;

  final IconData icon;

  final Color color;

  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        padding: EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: color.withOpacity(0.1),

                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(icon, color: color, size: 28),
            ),

            SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 4),

                  Text(subtitle, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
