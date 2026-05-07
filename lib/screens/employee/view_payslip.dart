import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/payslip_provider.dart';
import '../../providers/auth_provider.dart';

class ViewPayslips extends StatelessWidget {
  const ViewPayslips({super.key});

  @override
  Widget build(BuildContext context) {

    final payslipProvider = Provider.of<PayslipProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    final employeeName = auth.currentUser!.name;

    final employeePayslips = payslipProvider.payslips
        .where((p) => p.employeeName == employeeName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Payslips"),
      ),

      body: employeePayslips.isEmpty
          ? const Center(
              child: Text(
                "No payslips available",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: employeePayslips.length,
              itemBuilder: (context, index) {

                final payslip = employeePayslips[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(

                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.green,
                      size: 35,
                    ),

                    title: Text(
                      "Month: ${payslip.month}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      "Salary: \$${payslip.salary}",
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
    );
  }
}