// @dart=2.9
import 'package:flutter/material.dart';
import 'package:invoice_generator/widgets/app_data.dart';

class CustomerData extends StatelessWidget {
  const CustomerData({
    Key key,
    this.gstNo,
    this.customerName,
    this.address,
  }) : super(key: key);

  final String gstNo;
  final String customerName;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppData(
            dataLabel: gstNo,
            fontWeight: FontWeight.w500,
            colour: Colors.blue,
          ),
          AppData(
            dataLabel: customerName,
            fontWeight: FontWeight.w500,
          ),
          AppData(
            dataLabel: address,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
