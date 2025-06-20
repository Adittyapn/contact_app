import 'package:hive/hive.dart';
import '../models/contact.dart';

class ContactDB {
  static final _box = Hive.box<Contact>('contacts');

  static List<Contact> getAllContacts() {
    return _box.values.toList();
  }

  static void addContact(Contact contact) {
    _box.add(contact);
  }

  static void updateContact(int index, Contact updatedContact) {
    _box.putAt(index, updatedContact);
  }

  static void deleteContact(int index) {
    _box.deleteAt(index);
  }

  static Contact getContact(int index) {
    return _box.getAt(index)!;
  }

  static int getContactCount() {
    return _box.length;
  }
}
