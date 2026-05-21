import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {

  bool notifications = true;

  bool locationAccess = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Settings",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        iconTheme:
            const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// ACCOUNT
            const Text(
              "Account",

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset:
                        const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [

                  ListTile(
                    leading: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.orange
                            .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.person,
                        color:
                            Colors.orange,
                      ),
                    ),

                    title: const Text(
                      "Edit Profile",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "Change name and email",
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {},
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.orange
                            .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.lock,
                        color:
                            Colors.orange,
                      ),
                    ),

                    title: const Text(
                      "Privacy",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "Manage privacy settings",
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {},
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.orange
                            .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.language,
                        color:
                            Colors.orange,
                      ),
                    ),

                    title: const Text(
                      "Language",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "English",
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// APP SETTINGS
            const Text(
              "App Settings",

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset:
                        const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [

                  SwitchListTile(
                    value: notifications,

                    activeColor:
                        Colors.orange,

                    secondary: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.orange
                            .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.notifications,
                        color:
                            Colors.orange,
                      ),
                    ),

                    title: const Text(
                      "Notifications",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "Enable app notifications",
                    ),

                    onChanged: (value) {

                      setState(() {
                        notifications =
                            value;
                      });

                    },
                  ),

                  const Divider(height: 1),

                  SwitchListTile(
                    value: locationAccess,

                    activeColor:
                        Colors.orange,

                    secondary: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.orange
                            .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.location_on,
                        color:
                            Colors.orange,
                      ),
                    ),

                    title: const Text(
                      "Location Access",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "Allow location services",
                    ),

                    onChanged: (value) {

                      setState(() {
                        locationAccess =
                            value;
                      });

                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// SUPPORT
            const Text(
              "Support",

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset:
                        const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [

                  ListTile(
                    leading: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.orange
                            .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.help,
                        color:
                            Colors.orange,
                      ),
                    ),

                    title: const Text(
                      "Help Center",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "Get support",
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {},
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.orange
                            .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.info,
                        color:
                            Colors.orange,
                      ),
                    ),

                    title: const Text(
                      "About App",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "Version 1.0.0",
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {},
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.orange
                            .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.star,
                        color:
                            Colors.orange,
                      ),
                    ),

                    title: const Text(
                      "Rate Us",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "Give your feedback",
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}