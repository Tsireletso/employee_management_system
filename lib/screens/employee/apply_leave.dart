import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/leave_provider.dart';
import '../../models/leave_model.dart';
import '../../providers/auth_provider.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final reasonController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  /// Pick a date
  Future<void> _pickDate({required bool isStart}) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(DateTime.now().year - 1);
    DateTime lastDate = DateTime(DateTime.now().year + 2);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;

          // If end date is before start date, reset it
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
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Apply Leave")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDate(isStart: true),
                    child: Text(
                      startDate == null
                          ? "Select Start Date"
                          : "Start: ${startDate!.toLocal()}".split(' ')[0],
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
                          ? "Select End Date"
                          : "End: ${endDate!.toLocal()}".split(' ')[0],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (reasonController.text.isEmpty ||
                    startDate == null ||
                    endDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                if (endDate!.isBefore(startDate!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("End date cannot be before start date"),
                    ),
                  );
                  return;
                }

                final user = auth.currentUser;
                if (user == null) return;

                final leave = LeaveModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  employeeId: user.id,
                  employeeName: user.name,
                  reason: reasonController.text,

                  startDate: startDate!, // ✅ FORCE UNWRAP after validation
                  endDate: endDate!, // ✅ FORCE UNWRAP after validation

                  numberOfDays: endDate!.difference(startDate!).inDays + 1, leaveType: '',
                );

                (leaveProvider as dynamic).addLeave(leave);

                // Reset form
                setState(() {
                  reasonController.clear();
                  startDate = null;
                  endDate = null;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Leave request submitted")),
                );
              },
              child: const Text("Submit Leave Request"),
            ),
          ],
        ),
      ),
    );
  }
}
