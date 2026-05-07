import 'package:employee_management_system/models/leave_model.dart';
import 'package:employee_management_system/providers/auth_provider.dart';
import 'package:employee_management_system/providers/leave_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({super.key});

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  final reasonController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  String leaveType = "Annual Leave";

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;

          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Apply Leave")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// LEAVE TYPE
            DropdownButtonFormField<String>(
              value: leaveType,
              items: const [
                DropdownMenuItem(
                  value: "Annual Leave",
                  child: Text("Annual Leave"),
                ),
                DropdownMenuItem(
                  value: "Sick Leave",
                  child: Text("Sick Leave"),
                ),
                DropdownMenuItem(
                  value: "Emergency",
                  child: Text("Emergency"),
                ),
              ],
              onChanged: (val) => setState(() => leaveType = val!),
            ),

            const SizedBox(height: 10),

            /// DATE PICKERS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDate(isStart: true),
                    child: Text(
                      startDate == null
                          ? "Select Start"
                          : "Start: ${startDate!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: startDate == null
                        ? null
                        : () => _pickDate(isStart: false),
                    child: Text(
                      endDate == null
                          ? "Select End"
                          : "End: ${endDate!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// REASON
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// SUBMIT BUTTON
            ElevatedButton(
              onPressed: () async {
                if (startDate == null ||
                    endDate == null ||
                    reasonController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                if (endDate!.isBefore(startDate!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid date range")),
                  );
                  return;
                }

                if (user == null) return;

                final days =
                    LeaveModel.calculateDays(startDate!, endDate!);

                final leave = LeaveModel(
                  employeeId: user.id,        // ✅ REAL USER
                  employeeName: user.name,    // ✅ REAL USER
                  startDate: startDate!,
                  endDate: endDate!,
                  reason: reasonController.text,
                  numberOfDays: days,
                  leaveType: leaveType,
                );

                await leaveProvider.applyLeave(leave);

                setState(() {
                  startDate = null;
                  endDate = null;
                  reasonController.clear();
                  leaveType = "Annual Leave";
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Leave submitted successfully")),
                );

                Navigator.pop(context);
              },
              child: const Text("Submit Leave"),
            )
          ],
        ),
      ),
    );
  }
}