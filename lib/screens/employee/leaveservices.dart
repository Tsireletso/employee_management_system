import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_management_system/models/leave_model.dart';


class LeaveService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CREATE LEAVE
  Future<void> submitLeave(LeaveModel leave) async {
    await _db.collection("leaves").add(leave.toMap());
  }

  // STREAM ALL LEAVES (ADMIN)
  Stream<List<LeaveModel>> getAllLeaves() {
    return _db.collection("leaves")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => LeaveModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // STREAM ONLY EMPLOYEE LEAVES
  Stream<List<LeaveModel>> getEmployeeLeaves(String employeeId) {
    return _db
        .collection("leaves")
        .where("employeeId", isEqualTo: employeeId)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => LeaveModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // UPDATE STATUS (ADMIN APPROVAL)
  Future<void> updateStatus(String id, String status) async {
    await _db.collection("leaves").doc(id).update({
      "status": status,
    });
  }
}