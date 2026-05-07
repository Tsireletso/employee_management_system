import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: oldPassword,
              decoration: const InputDecoration(labelText: "Old Password"),
              obscureText: true,
            ),
            TextField(
              controller: newPassword,
              decoration: const InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            TextField(
              controller: confirmPassword,
              decoration: const InputDecoration(labelText: "Confirm New Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Change Password"),
              onPressed: () {
                // Check if new password matches confirmation
                if (newPassword.text != confirmPassword.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match")),
                  );
                  return;
                }

                // Call AuthProvider method
                final success = auth.changePassword(oldPassword.text, newPassword.text);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? "Password Changed" : "Old password incorrect"),
                  ),
                );

                if (success) {
                  oldPassword.clear();
                  newPassword.clear();
                  confirmPassword.clear();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}