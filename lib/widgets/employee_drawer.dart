import 'package:employee_management_system/providers/auth_provider.dart';
import 'package:employee_management_system/screens/auth/login_screen.dart';
import 'package:employee_management_system/screens/employee/apply_leave.dart';
import 'package:employee_management_system/screens/employee/view_payslip.dart';
import 'package:employee_management_system/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeDrawer extends StatelessWidget {
  const EmployeeDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser!;

    return Drawer(
      child: Column(
        children: [

          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.time_to_leave),
            title: const Text("Apply Leave"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ApplyLeave(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text("Payslips"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ViewPayslips(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),

          const Spacer(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {

              auth.logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );

            },
          )

        ],
      ),
    );
  }
}