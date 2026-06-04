// bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = Responsive.w(context);
    final isTablet = Responsive.isTablet(context);

    const items = [
      (Icons.food_bank, 'Home'),
      (Icons.category_outlined, 'Categories'),
      (Icons.add_shopping_cart_rounded, 'Cart'),
      (Icons.receipt_long_rounded, 'Orders'),
      (Icons.payments_rounded, 'Payment'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: isTablet ? 90 : 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (i) {
              final active = selectedIndex == i;

              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 18 : width * 0.025,
                    vertical: isTablet ? 10 : 6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[i].$1,
                        size: active
                            ? (isTablet ? 32 : 26)
                            : (isTablet ? 26 : 22),
                        color: active ? Colors.orange : Colors.grey,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          fontSize: active
                              ? (isTablet ? 13 : 11)
                              : (isTablet ? 11 : 10),
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.orange : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}