// @dart=2.9
import 'package:flutter/material.dart';
import 'package:invoice_generator/widgets/app_data.dart';

class InvoiceData extends StatelessWidget {
  const InvoiceData({
    Key key,
    this.invoiceId,
    this.customer,
    this.grandTotal,
  }) : super(key: key);

  final String invoiceId;
  final dynamic customer;
  final double grandTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppData(
            dataLabel: invoiceId,
            fontWeight: FontWeight.w500,
            colour: Colors.blue,
          ),
          AppData(
            dataLabel: customer != null ? customer['customerName'] : "-",
            fontWeight: FontWeight.w500,
          ),
          AppData(
            dataLabel: (grandTotal ?? "-").toString(),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
