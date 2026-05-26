import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Filters",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sort & Filter",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            Wrap(
              spacing: 12,
              runSpacing: 12,
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
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : Colors.white,

                          borderRadius: BorderRadius.circular(30),

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
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, currentFilter);
                },
                child: Text(
                  "Apply Filter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
