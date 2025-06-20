import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact.dart';
import '../widgets/contact_item.dart';
import 'add_contact_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBox = Hive.box<Contact>('contacts');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Apps"),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),

      body: Column(
        children: [
          const Divider(thickness: 1, color: Colors.grey, height: 1),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: contactBox.listenable(),
              builder: (context, Box<Contact> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text("No contacts yet."));
                }

                final contacts = box.values.toList()
                  ..sort(
                    (a, b) =>
                        a.name.toLowerCase().compareTo(b.name.toLowerCase()),
                  );

                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ContactItem(contact: contact, index: index);
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddContactPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
