import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/payslip_provider.dart';
import '../../models/payslip_model.dart';

class UploadPayslip extends StatefulWidget {
  const UploadPayslip({super.key});

  @override
  State<UploadPayslip> createState() => _UploadPayslipState();
}

class _UploadPayslipState extends State<UploadPayslip> {

  final employee = TextEditingController();
  final month = TextEditingController();
  final salary = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final payslipProvider = Provider.of<PayslipProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Upload Payslip")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: employee,
              decoration: const InputDecoration(labelText: "Employee Name"),
            ),

            TextField(
              controller: month,
              decoration: const InputDecoration(labelText: "Month"),
            ),

            TextField(
              controller: salary,
              decoration: const InputDecoration(labelText: "Salary"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Upload"),
              onPressed: () {

                payslipProvider.uploadPayslip(
                  PayslipModel(
                    employeeName: employee.text,
                    month: month.text,
                    salary: double.parse(salary.text),
                  ),
                );

                employee.clear();
                month.clear();
                salary.clear();
              },
            )

          ],
        ),
      ),
    );
  }
}