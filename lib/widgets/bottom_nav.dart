import 'package:flutter/material.dart';

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
    const items = [
      (Icons.home, 'Home'),
      (Icons.receipt_long, 'Orders'),
      (Icons.payment, 'Payment'), 
      (Icons.person, 'Profile'),
    ];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
      
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = selectedIndex == i;

          return GestureDetector(
            onTap: () => onTap(i), 

            child: AnimatedContainer(
              duration:  Duration(milliseconds: 300),
              padding:  EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].$1,
                    size: active ? 28 : 24,
                    color: active ? Colors.orange : Colors.grey,
                  ),
                   SizedBox(height: 4),
                  Text(
                  
                    items[i].$2,
                    style: TextStyle(
                      fontSize: active ? 13 : 11,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.orange : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
