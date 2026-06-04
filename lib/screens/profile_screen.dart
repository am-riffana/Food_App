import 'package:flutter/material.dart';
import 'package:foodapp/screens/cart_screen.dart';
import 'package:foodapp/screens/login_screen.dart';
import 'package:foodapp/screens/orders_screen.dart';
import 'package:foodapp/widgets/address.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:foodapp/widgets/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = Responsive.w(context);
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    
    final double hPad =
        isDesktop
            ? screenWidth * 0.2
            : isTablet
            ? screenWidth * 0.08
            : 16.0;

    final double avatarSize =
        isDesktop
            ? 110.0
            : isTablet
            ? 90.0
            : 72.0;

    final double nameFontSize =
        isDesktop
            ? 34.0
            : isTablet
            ? 30.0
            : 24.0;

    final double emailFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;

    final double headerTopPad =
        isDesktop
            ? 70.0
            : isTablet
            ? 65.0
            : 55.0;

    final double iconSize =
        isDesktop
            ? 32.0
            : isTablet
            ? 30.0
            : 26.0;

    final double tileFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 15.0;

    final double logoutHeight =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 54.0;

    final double logoutFontSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 18.0
            : 16.0;
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final user = Supabase.instance.client.auth.currentUser;
        final email = user?.email ?? "user@email.com";
        final name =
            user?.userMetadata?['name'] ??
            user?.userMetadata?['full_name'] ??
            email.split("@")[0];
        return Scaffold(
          backgroundColor: const Color(0xFFF6F6F6),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: headerTopPad,
                    left: hPad,
                    right: hPad,
                    bottom: 28,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF7A00), Color(0xFFFFA726)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(34),
                      bottomRight: Radius.circular(34),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet || isDesktop ? 28 : 20),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: avatarSize / 2,
                              backgroundColor: Colors.white,
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : "U",
                                style: TextStyle(
                                  fontSize: avatarSize * 0.42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            SizedBox(height: isTablet || isDesktop ? 14 : 10),
                            Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: emailFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet || isDesktop ? 28 : 20),
                      Container(
                        padding: EdgeInsets.all(
                          isTablet || isDesktop ? 20 : 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                isTablet || isDesktop ? 16 : 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: iconSize,
                              ),
                            ),
                            SizedBox(width: isTablet || isDesktop ? 16 : 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home Address",
                                    style: TextStyle(
                                      fontSize: tileFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Calicut, Kerala",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: emailFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet || isDesktop ? 20 : 14,
                                  vertical: isTablet || isDesktop ? 12 : 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ManageAddressPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: emailFontSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet || isDesktop ? 30 : 22),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: Column(
                    children: [
                      _buildTile(
                        context: context,
                        icon: Icons.shopping_bag_outlined,
                        title: "My Orders",
                        subtitle: "Track your orders",
                        iconSize: iconSize,
                        titleFontSize: tileFontSize,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => OrdersPage()),
                            ),
                      ),
                      _buildTile(
                        context: context,
                        icon: Icons.shopping_cart_outlined,
                        title: "Cart",
                        subtitle: "View cart items",
                        iconSize: iconSize,
                        titleFontSize: tileFontSize,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CartPage()),
                            ),
                      ),
                      _buildTile(
                        context: context,
                        icon: Icons.settings,
                        title: "Settings",
                        subtitle: "Privacy & preferences",
                        iconSize: iconSize,
                        titleFontSize: tileFontSize,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SettingsPage()),
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet || isDesktop ? 30 : 22),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: SizedBox(
                    width: double.infinity,
                    height: logoutHeight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () => logout(context),
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: iconSize,
                      ),
                      label: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: logoutFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isTablet || isDesktop ? 40 : 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required double iconSize,
    required double titleFontSize,
    required VoidCallback onTap,
  }) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);

    return Container(
      margin: EdgeInsets.only(bottom: isTablet || isDesktop ? 20 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet || isDesktop ? 22 : 16,
          vertical: isTablet || isDesktop ? 14 : 8,
        ),
        leading: Container(
          padding: EdgeInsets.all(isTablet || isDesktop ? 14 : 11),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.grey, fontSize: titleFontSize - 2),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
