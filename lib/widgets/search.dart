import 'package:flutter/material.dart';

class FoodSearchBar extends StatelessWidget {

  final TextEditingController controller;

  final ValueChanged<String>
      onSearchChanged;

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

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [

          const Icon(
            Icons.search,
            color: Colors.grey,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,

              onTap: onSearchTap,

              onChanged:
                  onSearchChanged,

              decoration:
                  const InputDecoration(
                hintText:
                    "Search foods, restaurants...",

                border:
                    InputBorder.none,

                isCollapsed: true,
              ),
            ),
          ),

          if (controller
              .text
              .isNotEmpty)

            GestureDetector(
              onTap: onClear,

              child: const Icon(
                Icons.close,
                size: 20,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}