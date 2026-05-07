import 'package:employee_management_system/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageLogin extends StatelessWidget {
  const ManageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Login")),
      body: ListView.builder(
        itemCount: authProvider.users.length,
        itemBuilder: (_, index) {
          final user = authProvider.users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.lock_reset),
                  onPressed: () => authProvider.resetPassword(user.id),
                ),
                Switch(
                  value: user.isActive,
                  onChanged: (val) => authProvider.toggleActive(user.id, val),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}