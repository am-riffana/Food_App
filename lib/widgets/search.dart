import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';

class FoodSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSearchTap;
  final bool isSearching;

  const FoodSearchBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    this.onClear,
    this.onSearchTap,
    this.isSearching = false,
  });

  double scale(BuildContext context, double v) {
    if (Responsive.isDesktop(context)) return v * 1.2;
    if (Responsive.isTablet(context)) return v * 1.1;
    return v;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: scale(context, 14),
        vertical: scale(context, 10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(scale(context, 16)),
        boxShadow:  [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
            size: scale(context, 22),
          ),

          SizedBox(width: scale(context, 10)),

          Expanded(
            child: TextField(
              controller: controller,
              onTap: onSearchTap,
              onChanged: onSearchChanged,
              style: TextStyle(fontSize: scale(context, 14)),
              decoration: InputDecoration(
                hintText: "Search foods, restaurants...",
                hintStyle: TextStyle(
                  fontSize: scale(context, 13),
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),

          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.close,
                color: Colors.grey,
                size: scale(context, 20),
              ),
            ),
        ],
      ),
    );
  }
}