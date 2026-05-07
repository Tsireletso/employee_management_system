import 'package:employee_management_system/providers/auth_provider.dart';
import 'package:employee_management_system/screens/admin/manage_employee.dart';
import 'package:employee_management_system/screens/admin/manage_login.dart';
import 'package:employee_management_system/screens/admin/manage_salary.dart';
import 'package:employee_management_system/screens/admin/manage_users.dart';
import 'package:employee_management_system/screens/auth/login_screen.dart';
import 'package:employee_management_system/screens/profile/change_password.dart';
import 'package:employee_management_system/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final userName = user.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Welcome Card
            Card(
              elevation: 4,
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.admin_panel_settings),
                ),
                title: const Text("Welcome Back"),
                subtitle: Text(userName),
              ),
            ),

            const SizedBox(height: 20),

            /// Quick Actions
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// Action Cards Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: [

                _actionCard(context, "Manage Users", Icons.people, const ManageUsers()),
                _actionCard(context, "Manage Salary", Icons.attach_money, const ManageSalary()),
                _actionCard(context, "Manage Employees", Icons.badge, const ManageEmployee()),
               // _actionCard(context, "Manage Leaves", Icons.event_note, const ManageLeaves()),
                _actionCard(context, "Manage Login", Icons.login, const ManageLogin()),
                _actionCard(context, "Update Profile", Icons.person, const ProfileScreen()),
                _actionCard(context, "Change Password", Icons.lock, const ChangePassword()),

              ],
            ),

          ],
        ),
      ),
    );
  }

  /// Generic action card widget
  Widget _actionCard(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}