// lib/models/employee_model.dart
import 'user_model.dart';

class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role, required String position, required String department,
  });

  // Convert Employee to User for login
  UserModel toUserModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      password: password,
      role: role,
      isActive: true,
    );
  }
}