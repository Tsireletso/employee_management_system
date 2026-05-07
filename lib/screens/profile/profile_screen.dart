import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'change_password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final name = TextEditingController();
  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser!;

    name.text = user.name;
    email.text = user.email;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Update Profile"),
              onPressed: () {

                user.name = name.text;
                user.email = email.text;

                // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                auth.notifyListeners();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Updated")),
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Change Password"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePassword(),
                  ),
                );
              },
            )

          ],
        ),
      ),
    );
  }
}