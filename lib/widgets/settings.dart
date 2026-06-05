import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool locationAccess = true;

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
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 24 : width * 0.055,
          ),
        ),

        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Account",
              style: TextStyle(
                fontSize: isTablet ? 26 : width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: height * 0.02),

            _buildCard(
              context,
              children: [
                _buildTile(
                  context,
                  icon: Icons.person,
                  title: "Edit Profile",
                  subtitle: "Change name and email",
                  onTap: () {},
                ),

                Divider(height: 1),

                _buildTile(
                  context,
                  icon: Icons.lock,
                  title: "Privacy",
                  subtitle: "Manage privacy settings",
                  onTap: () {},
                ),

                Divider(height: 1),

                _buildTile(
                  context,
                  icon: Icons.language,
                  title: "Language",
                  subtitle: "English",
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: height * 0.03),

            Text(
              "App Settings",
              style: TextStyle(
                fontSize: isTablet ? 26 : width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: height * 0.02),

            _buildCard(
              context,
              children: [
                SwitchListTile(
                  value: notifications,
                  activeColor: Colors.orange,

                  secondary: _buildIconBox(Icons.notifications),

                  title: Text(
                    "Notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 17 : width * 0.042,
                    ),
                  ),

                  subtitle: Text(
                    "Enable app notifications",
                    style: TextStyle(fontSize: isTablet ? 14 : width * 0.035),
                  ),

                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),

                Divider(height: 1),

                SwitchListTile(
                  value: locationAccess,
                  activeColor: Colors.orange,

                  secondary: _buildIconBox(Icons.location_on),

                  title: Text(
                    "Location Access",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 17 : width * 0.042,
                    ),
                  ),

                  subtitle: Text(
                    "Allow location services",
                    style: TextStyle(fontSize: isTablet ? 14 : width * 0.035),
                  ),

                  onChanged: (value) {
                    setState(() {
                      locationAccess = value;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: height * 0.03),

            Text(
              "Support",
              style: TextStyle(
                fontSize: isTablet ? 26 : width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: height * 0.02),

            _buildCard(
              context,
              children: [
                _buildTile(
                  context,
                  icon: Icons.help,
                  title: "Help Center",
                  subtitle: "Get support",
                  onTap: () {},
                ),

                Divider(height: 1),

                _buildTile(
                  context,
                  icon: Icons.info,
                  title: "About App",
                  subtitle: "Version 1.0.0",
                  onTap: () {},
                ),

                Divider(height: 1),

                _buildTile(
                  context,
                  icon: Icons.star,
                  title: "Rate Us",
                  subtitle: "Give your feedback",
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Icon(icon, color: Colors.orange),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final width = Responsive.w(context);
    final isTablet = Responsive.isTablet(context);

    return ListTile(
      leading: _buildIconBox(icon),

      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTablet ? 17 : width * 0.042,
        ),
      ),

      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: isTablet ? 14 : width * 0.035),
      ),

      trailing: Icon(
        Icons.arrow_forward_ios,
        size: isTablet ? 18 : width * 0.04,
      ),

      onTap: onTap,
    );
  }
}
