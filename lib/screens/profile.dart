import 'package:flutter/material.dart';
import 'package:foodapp/screens/cart.dart';
import 'package:foodapp/screens/login_screen.dart';
import 'package:foodapp/screens/order.dart';
import 'package:foodapp/widgets/address.dart';
import 'package:foodapp/widgets/settings.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void logout(BuildContext context) async {
    Hive.box('orders').clear();

    await Supabase.instance.client.auth.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user =
        Supabase.instance.client.auth.currentUser;

    final email =
        user?.email ?? "user@email.com";

    final name =
        user?.userMetadata?['name'] ??
        user?.userMetadata?['full_name'] ??
        user?.email?.split("@")[0] ??
        "User";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// ORANGE TOP SECTION
            Container(
              width: double.infinity,

              padding: const EdgeInsets.only(
                top: 60,
                left: 20,
                right: 20,
                bottom: 30,
              ),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF7A00),
                    Color(0xFFFFA726),
                  ],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
              ),

              child: Column(
                children: [

                  /// BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,

                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: Container(
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: Colors.orange,

                          borderRadius:
                              BorderRadius.circular(14),

                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),

                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// USER NAME
                  Text(
                    name,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// EMAIL
                  Text(
                    email,

                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ADDRESS CARD
                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(24),
                    ),

                    child: Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: Colors.orange,

                            borderRadius:
                                BorderRadius.circular(18),
                          ),

                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Text(
                                "Home Address",

                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Calicut, Kerala",

                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.orange,

                            elevation: 0,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),

                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ManageAddressPage(),
                              ),
                            );

                          },

                          child: const Text(
                            "Edit",

                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// MENU SECTION
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Column(
                children: [

                  buildTile(
                    context: context,
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    subtitle: "Track your orders",

                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const OrdersPage(),
                        ),
                      );

                    },
                  ),

                  buildTile(
                    context: context,
                    icon: Icons.shopping_cart_outlined,
                    title: "Cart",
                    subtitle: "View cart items",

                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartPage(),
                        ),
                      );

                    },
                  ),

                  buildTile(
                    context: context,
                    icon: Icons.settings,
                    title: "Settings",
                    subtitle: "Privacy & preferences",

                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const SettingsPage(),
                        ),
                      );

                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: () =>
                      logout(context),

                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),

                  label: const Text(
                    "Logout",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        leading: Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Colors.orange,

            borderRadius:
                BorderRadius.circular(16),
          ),

          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),

        title: Text(
          title,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 4,
          ),

          child: Text(
            subtitle,

            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),

        onTap: onTap,
      ),
    );
  }
}