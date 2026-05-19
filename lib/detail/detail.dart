import 'package:flutter/material.dart';
import 'package:foodapp/models/resturant_model.dart';
import 'package:foodapp/screens/order.dart';
import 'package:hive_flutter/hive_flutter.dart';
class DetailsPage extends StatefulWidget {

  final Restaurant restaurant;

  const DetailsPage({super.key, required this.restaurant});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}
class _DetailsPageState extends State<DetailsPage> {

  late Box ordersBox;

  @override
  void initState() {
    super.initState();
    ordersBox = Hive.box('orders');
  }
  void addToCart(int qty) {

    ordersBox.add({
      "name": widget.restaurant.name,
      "image": widget.restaurant.images.isNotEmpty
          ? widget.restaurant.images.first
          : '',
      "price": widget.restaurant.price,
      "qty": qty,
      "status": "cart",
      "addedTime": DateTime.now().toIso8601String(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.restaurant.name} added to cart 🛒"),
      ),
    );

    Navigator.pop(context);
  }
  void openBottomSheet() {
    int qty = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.restaurant.name,
                    style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 15),

                  Text(
                    "₹${widget.restaurant.price}",
                    style:  TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      IconButton(
                        onPressed: () {
                          if (qty > 1) setState(() => qty--);
                        },
                        icon:  Icon(Icons.remove_circle),
                      ),
                      Text(
                        "$qty",
                        style:  TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => qty++);
                        },
                        icon:  Icon(Icons.add_circle),
                      ),
                    ],
                  ),
                   SizedBox(height: 10),

                  Text(
                    "Total: ₹${widget.restaurant.price * qty}",
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                   SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:  EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => addToCart(qty),
                      child:  Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final image = widget.restaurant.images.isNotEmpty
        ? widget.restaurant.images.first
        : 'https://via.placeholder.com/300';

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: openBottomSheet,
        label:  Text("Add"),
        icon:  Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:  EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name,
                    style:  TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 10),
                  Row(
                    children: [
                       Icon(Icons.star, color: Colors.orange),
                       SizedBox(width: 5),
                      Text(widget.restaurant.rating),
                       SizedBox(width: 15),
                       Icon(Icons.location_on, color: Colors.red),
                       SizedBox(width: 5),
                      Text(widget.restaurant.distance),
                    ],
                  ),
                   SizedBox(height: 15),
                  Container(
                    padding:  EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:  Row(
                      children: [
                        Icon(Icons.local_offer, color: Colors.orange),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "50% OFF up to ₹100 • Use WELCOME50",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 15),
                   Text(
                    "About this restaurant",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 8),
                   Text(
                    "Delicious food prepared with fresh ingredients. Fast delivery and hygienic packaging guaranteed.",
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}