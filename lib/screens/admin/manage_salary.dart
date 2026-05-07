import 'package:employee_management_system/models/salary_model.dart';
import 'package:employee_management_system/providers/salary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageSalary extends StatelessWidget {
  const ManageSalary({super.key});

  @override
  Widget build(BuildContext context) {
    final salaryProvider = Provider.of<SalaryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Salary")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showSalaryDialog(context),
      ),
      body: ListView.builder(
        itemCount: salaryProvider.salaries.length,
        itemBuilder: (_, index) {
          final salary = salaryProvider.salaries[index];
          return ListTile(
            title: Text(salary.employeeName),
            subtitle: Text("Amount: \$${salary.amount.toStringAsFixed(2)}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showSalaryDialog(context, salary: salary),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => salaryProvider.deleteSalary(salary.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSalaryDialog(BuildContext context, {SalaryModel? salary}) {
    final nameController = TextEditingController(text: salary?.employeeName ?? '');
    final amountController = TextEditingController(text: salary?.amount.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(salary == null ? "Add Salary" : "Edit Salary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Employee Name')),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final salaryProvider = Provider.of<SalaryProvider>(context, listen: false);
              final amount = double.tryParse(amountController.text);
              if (amount == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter valid amount")));
                return;
              }

              if (salary == null) {
                salaryProvider.addSalary(SalaryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  employeeName: nameController.text,
                  amount: amount,
                ));
              } else {
                salaryProvider.updateSalary(SalaryModel(
                  id: salary.id,
                  employeeName: nameController.text,
                  amount: amount,
                ));
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}