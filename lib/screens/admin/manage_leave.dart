import 'package:employee_management_system/screens/employee/leave_application_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/leave_provider.dart';


class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final leaveProvider = Provider.of<LeaveProvider>(context);

    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final myLeaves = leaveProvider.leaves
        .where((l) => l.employeeId == user.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Employee Dashboard")),

      body: Column(
        children: [
          Text("Welcome ${user.name}"),

          Text("Total Leaves: ${myLeaves.length}"),

          Expanded(
            child: ListView.builder(
              itemCount: myLeaves.length,
              itemBuilder: (context, index) {
                final leave = myLeaves[index];

                return ListTile(
                  title: Text(leave.leaveType),
                  subtitle: Text(leave.reason),
                  trailing: Text(leave.status),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LeaveApplicationScreen(),
            ),
          );
        },
      ),
    );
  }
}