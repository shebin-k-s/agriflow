import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgriFlow',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Farmer',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Farm Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.only(top: 10),
              child: ListTile(
                title: const Text('Total Fields: 3'),
                subtitle: const Text(
                    'Total Area: 150 acres\nActive Crops: Cotton, Wheat, Rice'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Notification Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Language'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('About'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
