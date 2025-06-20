import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/contact.dart';

class HiveDebugPage extends StatelessWidget {
  const HiveDebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('users');
    final contactBox = Hive.box<Contact>('contacts');

    return Scaffold(
      appBar: AppBar(title: const Text('Debug Hive Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📦 Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...userBox.values.map(
              (user) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.username),
                subtitle: Text('Password: ${user.password}'),
              ),
            ),
            const Divider(height: 32),

            const Text(
              '📞 Contacts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...contactBox.values.map(
              (contact) => ListTile(
                leading: const Icon(Icons.contact_phone),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
