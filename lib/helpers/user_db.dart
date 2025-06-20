import 'package:hive/hive.dart';
import '../models/user.dart';

class UserDB {
  static final _box = Hive.box<User>('users');

  static void registerUser(User user) {
    _box.add(user);
  }

  static User? getUserByUsername(String username) {
    try {
      return _box.values.firstWhere((u) => u.username == username);
    } catch (_) {
      return null;
    }
  }

  static bool isUsernameTaken(String username) {
    return _box.values.any((u) => u.username == username);
  }

  static List<User> getAllUsers() {
    return _box.values.toList();
  }
}
