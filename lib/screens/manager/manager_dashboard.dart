import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/leave_provider.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);

    final pendingLeaves = leaveProvider.leaves
        .where((l) => l.status == "Pending")
        .toList();

    final approvedLeaves = leaveProvider.leaves
        .where((l) => l.status == "Approved")
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Manager Dashboard")),

      body: ListView(
        children: [
          const Text("Pending Leaves"),

          ...pendingLeaves.map((leave) {
            return Card(
              child: ListTile(
                title: Text(leave.employeeName),
                subtitle: Text(leave.reason),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        leaveProvider.approveLeave(leave.id);
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        leaveProvider.rejectLeave(leave.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),

          const Divider(),

          const Text("Approved Leaves"),

          ...approvedLeaves.map((leave) {
            return ListTile(
              title: Text(leave.employeeName),
              subtitle: Text(leave.reason),
              trailing: Text(leave.status),
            );
          }),
        ],
      ),
    );
  }
}