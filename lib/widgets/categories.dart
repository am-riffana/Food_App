import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final List<(String, String)> categories;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

           SizedBox(height: 10),

          Wrap(
            spacing: 10,   // horizontal space
            runSpacing: 10, // vertical space
            children: List.generate(categories.length, (i) {
              final active = selectedIndex == i;

              return GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 50) / 3,
                  height: 80,
                  decoration: BoxDecoration(
                    color: active
                        ? const Color.fromARGB(255, 255, 181, 71)
                        : const Color(0xFFFFF9E5),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        categories[i].$1,
                        style:  TextStyle(fontSize: 24),
                      ),
                       SizedBox(height: 6),
                      Text(
                        categories[i].$2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: active ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}