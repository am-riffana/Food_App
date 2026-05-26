import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: Text(
          "Settings",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Account",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Icon(Icons.person, color: Colors.orange),
                    ),

                    title: Text(
                      "Edit Profile",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text("Change name and email"),

                    trailing: Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {},
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Icon(Icons.lock, color: Colors.orange),
                    ),

                    title: Text(
                      "Privacy",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text("Manage privacy settings"),

                    trailing: Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {},
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Icon(Icons.language, color: Colors.orange),
                    ),

                    title: Text(
                      "Language",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text("English"),

                    trailing: Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 28),

            Text(
              "App Settings",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [
                  SwitchListTile(
                    value: notifications,

                    activeColor: Colors.orange,

                    secondary: Container(
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Icon(Icons.notifications, color: Colors.orange),
                    ),

                    title: Text(
                      "Notifications",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text("Enable app notifications"),

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

                    secondary: Container(
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Icon(Icons.location_on, color: Colors.orange),
                    ),
                    title: Text(
                      "Location Access",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text("Allow location services"),
                    onChanged: (value) {
                      setState(() {
                        locationAccess = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),
            Text(
              "Support",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Icon(Icons.help, color: Colors.orange),
                    ),

                    title: Text(
                      "Help Center",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text("Get support"),

                    trailing: Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {},
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.info, color: Colors.orange),
                    ),
                    title: Text(
                      "About App",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Version 1.0.0"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.star, color: Colors.orange),
                    ),
                    title: Text(
                      "Rate Us",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Give your feedback"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
