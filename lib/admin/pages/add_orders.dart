import 'package:flutter/material.dart';

class AddOrders extends StatelessWidget {
  const AddOrders({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor:
            Colors.orange,

        title: const Text(
          "Orders",
        ),
      ),

      body: ListView.builder(
        padding:
            const EdgeInsets.all(16),

        itemCount: 10,

        itemBuilder: (context, index) {

          return Container(
            margin:
                const EdgeInsets.only(
              bottom: 16,
            ),

            padding:
                const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                const Text(
                  "Burger x2",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Customer: Rahul",
                ),

                const SizedBox(height: 8),

                const Text(
                  "₹240",
                ),

                const SizedBox(height: 14),

                Row(
                  children: [

                    Expanded(
                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green,
                        ),

                        onPressed: () {},

                        child: const Text(
                          "Accept",
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,
                        ),

                        onPressed: () {},

                        child: const Text(
                          "Reject",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}