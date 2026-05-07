import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// PROVIDERS
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/leave_provider.dart';
import 'providers/payslip_provider.dart';
import 'providers/salary_provider.dart';
import 'providers/user_provider.dart';

// SCREENS
import 'screens/onboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase correctly for Web/Android/Desktop
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// AUTH
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        /// EMPLOYEE PROVIDER
        ChangeNotifierProxyProvider<AuthProvider, EmployeeProvider>(
          create: (context) => EmployeeProvider(
            authProvider: context.read<AuthProvider>(),
          ),

          update: (_, authProvider, previous) =>
              previous ??
              EmployeeProvider(
                authProvider: authProvider,
              ),
        ),

        /// USER
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),

        /// SALARY
        ChangeNotifierProvider<SalaryProvider>(
          create: (_) => SalaryProvider(),
        ),

        /// LEAVE
        ChangeNotifierProvider<LeaveProvider>(
          create: (_) => LeaveProvider(),
        ),

        /// PAYSLIPS
        ChangeNotifierProvider<PayslipProvider>(
          create: (_) => PayslipProvider(),
        ),

        /// CHAT
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee Management System',

        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey.shade100,

          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),

          useMaterial3: true,
        ),

        home: const OnboardingScreen(),
      ),
    );
  }
}