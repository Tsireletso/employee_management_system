import 'package:employee_management_system/providers/auth_provider.dart';
import 'package:employee_management_system/providers/leave_provider.dart';
import 'package:employee_management_system/screens/employee/leave_application_screen.dart';
import 'package:employee_management_system/widgets/employee_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final leaveProvider = Provider.of<LeaveProvider>(context);

    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("No user logged in")));
    }

    final userName = user.name;

    final myLeaves =
        (((leaveProvider as dynamic).leaveApplications ?? <dynamic>[]) as List)
            .where((l) => l.employeeName == userName)
            .toList();

    return Scaffold(
      drawer: const EmployeeDrawer(),

      appBar: AppBar(title: const Text("Employee Leave Dashboard")),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4facfe), Color(0xff00f2fe)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Welcome Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Welcome, $userName 👋",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Leave Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.event_note,
                        size: 40,
                        color: Colors.blue,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        myLeaves.length.toString(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text(
                        "Total Leave Requests",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Recent Leave Requests",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                /// Leave List
                ListView.builder(
                  itemCount: myLeaves.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final leave = myLeaves[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: ListTile(
                        leading: const Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),

                        title: Text(leave.leaveType),

                        subtitle: Text(
                          "Days: ${leave.numberOfDays}\nReason: ${leave.reason}",
                        ),

                        trailing: Text(
                          leave.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: leave.status == "Approved"
                                ? Colors.green
                                : leave.status == "Rejected"
                                ? Colors.red
                                : Colors.orange,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// Apply Leave Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Apply Leave"),

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaveApplicationScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
