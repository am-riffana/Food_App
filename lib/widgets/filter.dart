import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';

class FilterPage extends StatefulWidget {
  final String selectedFilter;

  const FilterPage({super.key, required this.selectedFilter});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late String currentFilter;

  @override
  void initState() {
    super.initState();
    currentFilter = widget.selectedFilter;
  }

  final List<String> filters = [
    'All',
    'Low Price',
    'High Rating',
    'Fast Delivery',
    'Nearest',
  ];

  @override
  Widget build(BuildContext context) {
    final width = Responsive.w(context);
    final height = Responsive.h(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          "Filters",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 24 : width * 0.055,
          ),
        ),

        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: EdgeInsets.all(width * 0.05),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Sort & Filter",
              style: TextStyle(
                fontSize: isTablet ? 28 : width * 0.065,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: height * 0.03),

            Wrap(
              spacing: width * 0.03,
              runSpacing: width * 0.03,

              children:
                  filters.map((filter) {
                    final isSelected = currentFilter == filter;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentFilter = filter;
                        });
                      },

                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),

                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: height * 0.015,
                        ),

                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : Colors.white,

                          borderRadius: BorderRadius.circular(
                            isTablet ? 35 : 30,
                          ),

                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                          ),
                        ),

                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,

                            fontWeight: FontWeight.bold,

                            fontSize: isTablet ? 16 : width * 0.038,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              height: isTablet ? 65 : height * 0.07,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(context, currentFilter);
                },

                child: Text(
                  "Apply Filter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 20 : width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
