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

  double scale(BuildContext context, double value) {
    final isTablet = Responsive.isTablet(context);
    return isTablet ? value * 1.2 : value;
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.w(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme:  IconThemeData(color: Colors.black),
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: scale(context, 18),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _sectionTitle("Account", context),

            SizedBox(height: scale(context, 12)),

            _card([
              _tile(
                icon: Icons.person,
                title: "Edit Profile",
                subtitle: "Change name and email",
                onTap: () {},
              ),
              _divider(),
              _tile(
                icon: Icons.lock,
                title: "Privacy",
                subtitle: "Manage privacy settings",
                onTap: () {},
              ),
              _divider(),
              _tile(
                icon: Icons.language,
                title: "Language",
                subtitle: "English",
                onTap: () {},
              ),
            ]),

            SizedBox(height: scale(context, 20)),

            _sectionTitle("App Settings", context),

            SizedBox(height: scale(context, 12)),

            _card([
              SwitchListTile(
                value: notifications,
                activeColor: Colors.orange,
                secondary: _iconBox(Icons.notifications),
                title: _titleText("Notifications"),
                subtitle: _subText("Enable app notifications"),
                onChanged: (value) {
                  setState(() => notifications = value);
                },
              ),
              _divider(),
              SwitchListTile(
                value: locationAccess,
                activeColor: Colors.orange,
                secondary: _iconBox(Icons.location_on),
                title: _titleText("Location Access"),
                subtitle: _subText("Allow location services"),
                onChanged: (value) {
                  setState(() => locationAccess = value);
                },
              ),
            ]),

            SizedBox(height: scale(context, 20)),

            _sectionTitle("Support", context),

            SizedBox(height: scale(context, 12)),

            _card([
              _tile(
                icon: Icons.help,
                title: "Help Center",
                subtitle: "Get support",
                onTap: () {},
              ),
              _divider(),
              _tile(
                icon: Icons.info,
                title: "About App",
                subtitle: "Version 1.0.0",
                onTap: () {},
              ),
              _divider(),
              _tile(
                icon: Icons.star,
                title: "Rate Us",
                subtitle: "Give feedback",
                onTap: () {},
              ),
            ]),

            SizedBox(height: scale(context, 30)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: scale(context, 18),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow:  [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() =>  Divider(height: 1);

  Widget _iconBox(IconData icon) {
    return Container(
      padding:  EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.orange, size: 18),
    );
  }

  Widget _titleText(String text) {
    return Text(
      text,
      style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _subText(String text) {
    return  Text(
      "",
      style: TextStyle(fontSize: 12),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: _iconBox(icon),
      title: Text(
        title,
        style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style:  TextStyle(fontSize: 12),
      ),
      trailing:  Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}