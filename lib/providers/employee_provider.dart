// lib/providers/employee_provider.dart
import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import 'auth_provider.dart';

class EmployeeProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  final List<EmployeeModel> _employees = [];

  EmployeeProvider({required this.authProvider});

  List<EmployeeModel> get employees => List.unmodifiable(_employees);

void addEmployee(EmployeeModel employee) {
  _employees.add(employee);
  notifyListeners(); // 🔥 THIS IS CRITICAL
}

  void updateEmployee(EmployeeModel updatedEmployee) {
    final index = _employees.indexWhere((e) => e.id == updatedEmployee.id);
    if (index != -1) {
      _employees[index] = updatedEmployee;

      // Update auth user as well
      authProvider.updateUser(updatedEmployee.toUserModel());

      notifyListeners();
    }
  }

  void deleteEmployee(String id) {
    _employees.removeWhere((e) => e.id == id);
    authProvider.deleteUser(id);
    notifyListeners();
  }
}