import 'package:flutter/material.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() =>
      _AddFoodPageState();
}

class _AddFoodPageState
    extends State<AddFoodPage> {

  final nameController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final imageController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor:
            Colors.orange,

        title: const Text(
          "Add Food",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller:
                  nameController,

              decoration:
                  const InputDecoration(
                hintText:
                    "Food Name",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  priceController,

              decoration:
                  const InputDecoration(
                hintText:
                    "Price",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  imageController,

              decoration:
                  const InputDecoration(
                hintText:
                    "Image URL",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange,
                ),

                onPressed: () {

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(

                    const SnackBar(
                      content: Text(
                        "Food Added",
                      ),
                    ),
                  );
                },

                child: const Text(
                  "Add Food",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}