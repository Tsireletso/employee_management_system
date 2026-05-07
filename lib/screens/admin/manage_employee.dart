// lib/screens/admin/manage_employee.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/employee_provider.dart';
import '../../models/employee_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class ManageEmployee extends StatefulWidget {
  const ManageEmployee({super.key});

  @override
  State<ManageEmployee> createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Employees")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showEmployeeDialog(context),
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: employeeProvider.employees.isEmpty
                ? const Center(
                    child: Text(
                      "No employees added yet",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    key: ValueKey(employeeProvider.employees.length),
                    itemCount: employeeProvider.employees.length,
                    itemBuilder: (context, index) {
                      final employee = employeeProvider.employees[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              employee.name.isNotEmpty
                                  ? employee.name[0].toUpperCase()
                                  : "?",
                            ),
                          ),
                          title: Text("${employee.name} (${employee.role})"),
                          subtitle: Text("Email: ${employee.email}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _showEmployeeDialog(
                                  context,
                                  employee: employee,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => employeeProvider
                                    .deleteEmployee(employee.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  void _showEmployeeDialog(BuildContext context, {EmployeeModel? employee}) {
    final nameController = TextEditingController(text: employee?.name ?? '');
    final emailController = TextEditingController(text: employee?.email ?? '');
    final passwordController = TextEditingController(
      text: employee?.password ?? '',
    );
    final roleController = TextEditingController(
      text: employee?.role ?? 'employee',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(employee == null ? "Add Employee" : "Edit Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            DropdownButtonFormField(
              initialValue: roleController.text,
              items: const [
                DropdownMenuItem(value: 'employee', child: Text('Employee')),
                DropdownMenuItem(value: 'manager', child: Text('Manager')),
              ],
              onChanged: (val) => roleController.text = val.toString(),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final employeeProvider = Provider.of<EmployeeProvider>(
                context,
                listen: false,
              );

              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );

              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fill all fields")),
                );
                return;
              }

              if (employee == null) {
                final newEmployee = EmployeeModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  role: roleController.text,
                  position: '',
                  department: '',
                );

                // ✅ ADD TO EMPLOYEE LIST
                employeeProvider.addEmployee(newEmployee);

                // 🔥 ALSO ADD TO LOGIN SYSTEM
                authProvider.addUser(
                  UserModel(
                    id: newEmployee.id,
                    name: newEmployee.name,
                    email: newEmployee.email,
                    password: newEmployee.password,
                    role: newEmployee.role,
                    isActive: true,
                  ),
                );
              } else {
                final updatedEmployee = EmployeeModel(
                  id: employee.id,
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  role: roleController.text,
                  position: '',
                  department: '',
                );

                employeeProvider.updateEmployee(updatedEmployee);

                // 🔥 ALSO UPDATE LOGIN USER
                authProvider.updateUser(
                  UserModel(
                    id: updatedEmployee.id,
                    name: updatedEmployee.name,
                    email: updatedEmployee.email,
                    password: updatedEmployee.password,
                    role: updatedEmployee.role,
                    isActive: true,
                  ),
                );
              }

              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
