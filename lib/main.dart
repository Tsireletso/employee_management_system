import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/user_provider.dart';
import 'providers/salary_provider.dart';
import 'providers/leave_provider.dart';
import 'providers/payslip_provider.dart';
import 'providers/chat_provider.dart';

import 'screens/onboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ FIX

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProxyProvider<AuthProvider, EmployeeProvider>(
          create: (_) => EmployeeProvider(authProvider: AuthProvider()),
          update: (_, auth, __) =>
              EmployeeProvider(authProvider: auth),
        ),

        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SalaryProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
        ChangeNotifierProvider(create: (_) => PayslipProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Employee Management System",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const OnboardingScreen(),
      ),
    );
  }
}