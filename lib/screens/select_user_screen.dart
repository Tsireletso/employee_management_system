import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/auth_provider.dart';
import 'chat_screen.dart';

class SelectUserScreen extends StatelessWidget {
  const SelectUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    final currentUser = auth.currentUser;

    final users = employeeProvider.employees
        .where((e) => e.name != currentUser?.name)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Employee")),
      body: users.isEmpty
          ? const Center(child: Text("No employees available"))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user.name[0].toUpperCase()),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.role),
                    trailing: const Icon(Icons.chat),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChatScreen(receiverName: user.name),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}