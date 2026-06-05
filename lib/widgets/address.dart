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
    final width = Responsive.w(context);
    final height = Responsive.h(context);
    final isTablet = Responsive.isTablet(context);

    TextEditingController controller = TextEditingController(text: address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: width * 0.05,
            right: width * 0.05,
            top: height * 0.03,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: width * 0.15,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: height * 0.025),

              Text(
                "Edit Address",
                style: TextStyle(
                  fontSize: isTablet ? 26 : width * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: height * 0.025),

              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter address",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),

              SizedBox(
                width: double.infinity,
                height: isTablet ? 65 : 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      address = controller.text;
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 20 : width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.w(context);
    final height = Responsive.h(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Manage Address",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 24 : width * 0.05,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: editAddress,
        icon: Icon(
          Icons.add_location_alt,
          color: Colors.white,
          size: isTablet ? 28 : width * 0.06,
        ),
        label: Text(
          "Add Address",
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 18 : width * 0.04,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.045),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isTablet ? 30 : 24),
                boxShadow: [
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
                    padding: EdgeInsets.all(width * 0.035),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
                    ),
                    child: Icon(
                      Icons.home,
                      color: Colors.orange,
                      size: isTablet ? 36 : width * 0.07,
                    ),
                  ),

                  SizedBox(width: width * 0.04),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: isTablet ? 22 : width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: height * 0.008),

                        Text(
                          address,
                          style: TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                            fontSize: isTablet ? 16 : width * 0.035,
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
                      size: isTablet ? 30 : width * 0.06,
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
