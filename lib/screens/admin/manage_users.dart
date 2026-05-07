import 'package:employee_management_system/models/user_model.dart';
import 'package:employee_management_system/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageUsers extends StatelessWidget {
  const ManageUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Users")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showUserDialog(context),
      ),
      body: ListView.builder(
        itemCount: userProvider.users.length,
        itemBuilder: (_, index) {
          final user = userProvider.users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.role),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showUserDialog(context, user: user),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => userProvider.deleteUser(user.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showUserDialog(BuildContext context, {UserModel? user}) {
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    String role = user?.role ?? 'Employee';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? "Add User" : "Edit User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            DropdownButtonFormField(
              initialValue: role,
              items: const [
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                DropdownMenuItem(value: 'Employee', child: Text('Employee')),
              ],
              onChanged: (v) => role = v!,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              if (user == null) {
                userProvider.addUser(UserModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  email: emailController.text,
                  role: role, password: '',
                ));
              } else {
                userProvider.updateUser(UserModel(
                  id: user.id,
                  name: nameController.text,
                  email: emailController.text,
                  role: role, password: '',
                ));
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}