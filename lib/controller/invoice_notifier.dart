// @dart=2.9
import 'package:flutter/material.dart';

class InvoiceNotifier extends ChangeNotifier {
  int _invoiceId;

  int getInvoiceId() => _invoiceId;

  void setInvoiceId(int value) {
    _invoiceId = value;
    notifyListeners();
  }
}
