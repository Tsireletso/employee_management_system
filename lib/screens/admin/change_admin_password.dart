import 'package:employee_management_system/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: oldController, decoration: const InputDecoration(labelText: 'Old Password'), obscureText: true),
            TextField(controller: newController, decoration: const InputDecoration(labelText: 'New Password'), obscureText: true),
            TextField(controller: confirmController, decoration: const InputDecoration(labelText: 'Confirm Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (newController.text != confirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
                  return;
                }
                final success = auth.changePassword(oldController.text, newController.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? "Password changed" : "Old password incorrect")));
              },
              child: const Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}