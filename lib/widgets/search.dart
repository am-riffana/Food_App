import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 10,
        20,
        20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery to'),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14),
                      SizedBox(width: 4),
                      Text('Edappalam Pattambi'),
                    ],
                  ),
                ],
              ),
              Icon(Icons.notifications),
            ],
          ),

          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onTap: onSearchTap,
                          onChanged: onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search foods...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (controller.text.isNotEmpty)
                        GestureDetector(
                          onTap: onClear,
                          child: Icon(Icons.close, size: 18),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),

              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.tune, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
