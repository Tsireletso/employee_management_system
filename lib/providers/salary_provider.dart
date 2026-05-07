import 'package:employee_management_system/models/salary_model.dart';
import 'package:flutter/material.dart';

class SalaryProvider extends ChangeNotifier {
  final List<SalaryModel> _salaries = [];

  List<SalaryModel> get salaries => List.unmodifiable(_salaries);

  void addSalary(SalaryModel salary) {
    _salaries.add(salary);
    notifyListeners();
  }

  void updateSalary(SalaryModel updatedSalary) {
    final index = _salaries.indexWhere((s) => s.id == updatedSalary.id);
    if (index != -1) {
      _salaries[index] = updatedSalary;
      notifyListeners();
    }
  }

  void deleteSalary(String id) {
    _salaries.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ✅ Null-safe
  SalaryModel? getSalaryById(String id) {
    try {
      return _salaries.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  // Optional: Get salary history for employee
  List<SalaryModel> getSalariesByEmployee(String employeeName) {
    return _salaries.where((s) => s.employeeName == employeeName).toList();
  }
}