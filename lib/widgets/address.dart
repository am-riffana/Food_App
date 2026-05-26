import 'package:flutter/material.dart';

class ManageAddressPage extends StatefulWidget {
  const ManageAddressPage({super.key});

  @override
  State<ManageAddressPage> createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  String address = "Calicut, Kerala";

  void editAddress() {
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
            left: 20,
            right: 20,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 60,
                height: 5,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,

                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 22),

              Text(
                "Edit Address",

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

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

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 55,

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

                      fontSize: 18,

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
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: Text(
          "Manage Address",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: IconThemeData(color: Colors.black),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,

        onPressed: editAddress,

        icon: Icon(Icons.add_location_alt, color: Colors.white),

        label: Text("Add Address", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
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
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(Icons.home, color: Colors.orange, size: 28),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          address,
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: editAddress,
                    icon: Icon(Icons.edit, color: Colors.orange),
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
