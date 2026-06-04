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

  @override
  Widget build(BuildContext context) {
    final width = Responsive.w(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: width * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          isTablet ? 24 : width * 0.045,
        ),
        boxShadow: const [
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
            size: isTablet ? 28 : width * 0.06,
          ),

          SizedBox(width: width * 0.025),

          Expanded(
            child: TextField(
              controller: controller,
              onTap: onSearchTap,
              onChanged: onSearchChanged,

              style: TextStyle(
                fontSize: isTablet ? 18 : width * 0.04,
              ),

              decoration: InputDecoration(
                hintText: "Search foods, restaurants...",
                border: InputBorder.none,
                isCollapsed: true,

                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: isTablet ? 16 : width * 0.038,
                ),
              ),
            ),
          ),

          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.close,
                color: Colors.grey,
                size: isTablet ? 24 : width * 0.05,
              ),
            ),
        ],
      ),
    );
  }
}