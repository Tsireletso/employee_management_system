import 'package:employee_management_system/screens/employee/leaveservices.dart';
import 'package:flutter/material.dart';
import '../models/leave_model.dart';


class LeaveProvider extends ChangeNotifier {
  final LeaveService _service = LeaveService();

  List<LeaveModel> _leaves = [];

  List<LeaveModel> get leaves => _leaves;

  LeaveProvider() {
    loadLeaves();
  }

  // STREAM ALL LEAVES
  void loadLeaves() {
    _service.getAllLeaves().listen((data) {
      _leaves = data;
      notifyListeners();
    });
  }

  // APPLY LEAVE
  Future<void> applyLeave(LeaveModel leave) async {
    await _service.submitLeave(leave);
  }

  // UPDATE STATUS (APPROVE / REJECT)
  Future<void> updateStatus(String id, String status) async {
    await _service.updateStatus(id, status);
    loadLeaves();
  }
   // ✅ APPROVE LEAVE
  Future<void> approveLeave(String id) async {
    await _service.updateStatus(id, "Approved");
    loadLeaves(); // refresh UI
    notifyListeners();
  }

  // ❌ REJECT LEAVE
  Future<void> rejectLeave(String id) async {
    await _service.updateStatus(id, "Rejected");
    loadLeaves(); // refresh UI
    notifyListeners();
  }
}