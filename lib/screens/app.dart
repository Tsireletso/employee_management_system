import 'package:employee_management_system/providers/auth_provider.dart';
import 'package:employee_management_system/screens/employee/employee_dashboard.dart';
import 'package:employee_management_system/screens/manager/manager_dashboard.dart';
import 'package:employee_management_system/screens/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HR System",

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      home: _resolveHome(auth),
    );
  }

  Widget _resolveHome(AuthProvider auth) {
    final user = auth.currentUser;

    if (user == null) {
      return const OnboardingScreen();
    }

    /// 🔥 ROLE-BASED ROUTING (IMPORTANT)
    switch (user.role) {
      case "manager":
        return const ManagerDashboard();

      case "employee":
        return const EmployeeDashboard();

      case "admin":
        return const ManagerDashboard(); // replace later

      default:
        return const OnboardingScreen();
    }
  }
}