// @dart=2.9
import 'package:flutter/material.dart';
import 'package:invoice_generator/widgets/app_data.dart';

class ProductData extends StatelessWidget {
  const ProductData({
    Key key,
    this.particulars,
    this.hsnCode,
    this.rate,
  }) : super(key: key);

  final String particulars;
  final String hsnCode;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppData(
            dataLabel: particulars,
            fontWeight: FontWeight.w500,
            colour: Colors.blue,
          ),
          AppData(
            dataLabel: hsnCode,
            fontWeight: FontWeight.w500,
          ),
          AppData(
            dataLabel: rate,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
