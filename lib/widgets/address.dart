import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';

class ManageAddressPage extends StatefulWidget {
  const ManageAddressPage({super.key});

  @override
  State<ManageAddressPage> createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  String address = "Calicut, Kerala";

  void editAddress() {
    final controller = TextEditingController(text: address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final viewInsets = MediaQuery.of(context).viewInsets.bottom;
        final width = Responsive.w(context);
        final isTablet = Responsive.isTablet(context);

        double scale(double size) =>
            isTablet ? size * 1.2 : size;

        return Padding(
          padding: EdgeInsets.only(
            left: width * 0.05,
            right: width * 0.05,
            top: width * 0.05,
            bottom: viewInsets + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                SizedBox(height: scale(20)),

                Text(
                  "Edit Address",
                  style: TextStyle(
                    fontSize: scale(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: scale(20)),

                TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Enter address",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(scale(14)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: scale(25)),

                SizedBox(
                  width: double.infinity,
                  height: scale(50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        address = controller.text.trim();
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: scale(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.w(context);
    final isTablet = Responsive.isTablet(context);

    double scale(double size) => isTablet ? size * 1.2 : size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme:  IconThemeData(color: Colors.black),
        title: Text(
          "Manage Address",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: scale(18),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: editAddress,
        icon: Icon(
          Icons.add_location_alt,
          size: scale(22),
          color: Colors.white,
        ),
        label: Text(
          "Add Address",
          style: TextStyle(
            color: Colors.white,
            fontSize: scale(14),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(scale(14)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow:  [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(scale(10)),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.home,
                      color: Colors.orange,
                      size: scale(26),
                    ),
                  ),

                  SizedBox(width: scale(12)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: scale(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: scale(4)),
                        Text(
                          address,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: scale(13),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: editAddress,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.orange,
                      size: scale(22),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}