import 'package:employee_management_system/providers/auth_provider.dart';
import 'package:employee_management_system/providers/leave_provider.dart';
import 'package:employee_management_system/screens/employee/leave_application_screen.dart';
import 'package:employee_management_system/widgets/employee_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final leaveProvider = Provider.of<LeaveProvider>(context);

    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user logged in"),
        ),
      );
    }

    final userName = user.name;

    // ✅ FIXED
    final myLeaves = leaveProvider.leaves
        .where((leave) => leave.employeeName == userName)
        .toList();

    return Scaffold(
      drawer: const EmployeeDrawer(),

      appBar: AppBar(
        title: const Text("Employee Leave Dashboard"),
        centerTitle: true,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff4facfe),
              Color(0xff00f2fe),
            ],
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
                /// WELCOME CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome Back 👋",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),

                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// TOTAL LEAVE CARD
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
                        size: 45,
                        color: Colors.blue,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        myLeaves.length.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Total Leave Requests",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// SECTION TITLE
                const Text(
                  "Recent Leave Requests",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                /// EMPTY STATE
                if (myLeaves.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Center(
                      child: Text(
                        "No leave requests yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                /// LEAVE LIST
                ListView.builder(
                  itemCount: myLeaves.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemBuilder: (context, index) {
                    final leave = myLeaves[index];

                    Color statusColor = Colors.orange;

                    if (leave.status == "Approved") {
                      statusColor = Colors.green;
                    } else if (leave.status == "Rejected") {
                      statusColor = Colors.red;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),

                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(
                            Icons.calendar_month,
                            color: Colors.blue,
                          ),
                        ),

                        title: Text(
                          leave.leaveType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Days: ${leave.numberOfDays}",
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Reason: ${leave.reason}",
                              ),
                            ],
                          ),
                        ),

                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Text(
                            leave.status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 25),

                /// APPLY BUTTON
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),

                    label: const Text(
                      "Apply Leave",
                      style: TextStyle(fontSize: 16),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LeaveApplicationScreen(),
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