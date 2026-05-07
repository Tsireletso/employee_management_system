import 'package:employee_management_system/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AuthProvider extends ChangeNotifier {
  final List<UserModel> _users = [];
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  List<UserModel> get users => List.unmodifiable(_users);

  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(UserModel updatedUser) {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

 bool loginWithEmail(String email, String password) {

  try {

    final user = _users.firstWhere(
      (u) => u.email == email && u.password == password,
    );

    _currentUser = user;

    return true;

  } catch (e) {
    return false;
  }
}

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  bool changePassword(String oldPassword, String newPassword) {
    if (_currentUser == null) return false;
    if (_currentUser!.password != oldPassword) return false;
    _currentUser!.password = newPassword;
    notifyListeners();
    return true;
  }

  void resetPassword(String userId) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index].password = "123456"; // default password
      notifyListeners();
    }
  }

  void toggleActive(String userId, bool isActive) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index].isActive = isActive;
      notifyListeners();
    }
  }
//   void setupDefaultUsers(AuthProvider auth) {
//   auth.addUser(UserModel(
//     id: "1",
//     name: "Admin User",
//     email: "admin@example.com",
//     password: "admin123",
//     role: "admin",
//     isActive: true,
//   ));

//   auth.addUser(UserModel(
//     id: "2",
//     name: "Manager User",
//     email: "manager@example.com",
//     password: "manager123",
//     role: "manager",
//     isActive: true,
//   ));

//   auth.addUser(UserModel(
//     id: "3",
//     name: "Employee User",
//     email: "employee@example.com",
//     password: "employee123",
//     role: "employee",
//     isActive: true,
//   ));
// }

   // Create first admin (used in first-time setup)
  void createFirstAdmin(String name, String email, String password) {
    final id = const Uuid().v4();
    final admin = UserModel(
      id: id,
      name: name,
      email: email,
      password: password,
      role: "admin",
      isActive: true,
    );
    _users.add(admin);
    _currentUser = admin;
    notifyListeners();
  }
  void updateProfile(UserModel updatedUser) {
  updateUser(updatedUser);
}
void deleteUser(String id) {
  _users.removeWhere((u) => u.id == id);
  // Optional: if the deleted user is the current user, log them out
  if (_currentUser?.id == id) {
    _currentUser = null;
  }
  notifyListeners();
}
}
