import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';

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
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double hMargin = isDesktop
        ? screenWidth * 0.18
        : isTablet
            ? screenWidth * 0.06
            : 16.0;

    final double tilePadding = isDesktop
        ? 20.0
        : isTablet
            ? 18.0
            : 16.0;

    final double iconSize = isDesktop
        ? 32.0
        : isTablet
            ? 30.0
            : 28.0;

    final double iconPad = isDesktop
        ? 16.0
        : isTablet
            ? 14.0
            : 12.0;

    final double titleSize = isDesktop
        ? 19.0
        : isTablet
            ? 18.0
            : 17.0;

    final double subtitleSize = isDesktop
        ? 14.0
        : isTablet
            ? 13.5
            : 13.0;

    final double arrowSize = isDesktop
        ? 18.0
        : isTablet
            ? 17.0
            : 16.0;

    final double vMargin = isDesktop
        ? 10.0
        : isTablet
            ? 9.0
            : 8.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: hMargin, vertical: vMargin),
        padding: EdgeInsets.all(tilePadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow:  [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(iconPad),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: iconSize),
            ),

            SizedBox(width: isTablet || isDesktop ? 20 : 16),

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
                   SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: subtitleSize,
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: arrowSize, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}