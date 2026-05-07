import 'package:flutter/material.dart';
import '../models/payslip_model.dart';

class PayslipProvider with ChangeNotifier {

  List<PayslipModel> payslips = [];

  void uploadPayslip(PayslipModel slip) {
    payslips.add(slip);
    notifyListeners();
  }
}