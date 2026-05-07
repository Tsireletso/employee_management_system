import 'package:flutter/material.dart';

class LeaveRequests extends StatelessWidget {
  const LeaveRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Requests")),
      body: const Center(child: Text("Leave Requests Page")),
    );
  }
}