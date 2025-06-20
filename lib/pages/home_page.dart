// home_page.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact.dart';
import '../models/user.dart';
import '../helpers/contact_db.dart';
import 'add_contact_page.dart';
import 'login_page.dart';
import 'hive_debug_page.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final contactBox = Hive.box<Contact>('contacts');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Apps"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal[100],
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.person, size: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  'Selamat datang, ${user.username}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

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

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: Text(
                              contact.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            contact.phone,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddContactPage(
                                        contact: contact,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Hapus Kontak'),
                                      content: const Text(
                                        'Apakah kamu yakin ingin menghapus kontak ini?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Tidak'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            ContactDB.deleteContact(index);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ya'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: SizedBox(
        width: 140,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'debug',
              mini: true,
              backgroundColor: Colors.grey[300],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HiveDebugPage()),
                );
              },
              tooltip: 'Lihat Data',
              child: const Icon(Icons.bug_report, color: Colors.black87),
            ),
            const SizedBox(width: 12),

            FloatingActionButton(
              heroTag: 'add',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddContactPage()),
              ),
              tooltip: 'Tambah Kontak',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
