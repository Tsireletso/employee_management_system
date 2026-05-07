class LeaveModel {
  String id;
  String employeeId;
  String employeeName;

  DateTime? startDate;
  DateTime? endDate;

  String reason;
  String leaveType;

  int numberOfDays;
  String status;

  LeaveModel({
    this.id = '',
    required this.employeeId,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.leaveType,
    required this.numberOfDays,
    this.status = "Pending",
  });

  static int calculateDays(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  /// ✅ FIX: Firestore → App
  factory LeaveModel.fromMap(String id, Map<String, dynamic> data) {
    return LeaveModel(
      id: id,
      employeeId: data['employeeId'] ?? '',
      employeeName: data['employeeName'] ?? '',
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
      reason: data['reason'] ?? '',
      leaveType: data['leaveType'] ?? 'Annual Leave',
      numberOfDays: data['numberOfDays'] ?? 0,
      status: data['status'] ?? 'Pending',
    );
  }

  /// ✅ FIX: App → Firestore
  Map<String, dynamic> toMap() {
    return {
      "employeeId": employeeId,
      "employeeName": employeeName,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "reason": reason,
      "leaveType": leaveType,
      "numberOfDays": numberOfDays,
      "status": status,
      "createdAt": DateTime.now().toIso8601String(),
    };
  }
  
}