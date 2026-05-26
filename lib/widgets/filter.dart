import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final String selectedFilter;

  const FilterPage({
    super.key,
    required this.selectedFilter,
  });

  @override
  State<FilterPage> createState() =>
      _FilterPageState();
}

class _FilterPageState
    extends State<FilterPage> {
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
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Filters",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme:
            const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Sort & Filter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: filters.map((filter) {
                final isSelected =
                    currentFilter == filter;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentFilter = filter;
                    });
                  },

                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 200),

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orange
                          : Colors.white,

                      borderRadius:
                          BorderRadius.circular(30),

                      border: Border.all(
                        color: isSelected
                            ? Colors.orange
                            : Colors.grey.shade300,
                      ),
                    ),

                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(
                    context,
                    currentFilter,
                  );
                },

                child: const Text(
                  "Apply Filter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
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