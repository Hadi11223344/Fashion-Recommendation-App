import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 24),
            _buildSectionTitle("Account Settings"),
            const SizedBox(height: 16),
            _buildSettingsOptions(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage("https://placehold.co/60x60"),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Muhammad Faisal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF060A0F),
              ),
            ),
            Text(
              'faisal@outfyt.com',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8C9096),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF060A0F),
      ),
    );
  }

  Widget _buildSettingsOptions() {
    final List<Map<String, dynamic>> settingsOptions = [
      {"title": "Notifications", "icon": Icons.notifications},
      {"title": "Customer Support", "icon": Icons.support_agent},
      {"title": "Password & Security", "icon": Icons.lock},
      {"title": "About", "icon": Icons.info},
      {"title": "Sign Out", "icon": Icons.logout, "isLogout": true},
    ];

    return Column(
      children: settingsOptions.map((option) {
        return Column(
          children: [
            ListTile(
              leading: Icon(
                option["icon"],
                color: option["isLogout"] == true ? Colors.red : Colors.black,
              ),
              title: Text(
                option["title"],
                style: TextStyle(
                  fontSize: 14,
                  color: option["isLogout"] == true ? Colors.red : Colors.black,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Implement navigation or functionality
              },
            ),
            Divider(color: Colors.grey[300]),
          ],
        );
      }).toList(),
    );
  }
}
