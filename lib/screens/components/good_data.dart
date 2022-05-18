// @dart=2.9
import 'package:flutter/material.dart';
import 'package:invoice_generator/widgets/app_data.dart';

class GoodData extends StatelessWidget {
  const GoodData({
    Key key,
    this.particular,
    this.hsnCode,
    this.rate,
    this.quantity,
    this.amount,
  }) : super(key: key);

  final String particular;
  final String hsnCode;
  final String rate;
  final String quantity;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (particular != null)
            AppData(
              dataLabel: particular,
              fontWeight: FontWeight.w500,
              colour: Colors.blue,
            ),
          if (hsnCode != null)
            AppData(
              dataLabel: hsnCode,
              fontWeight: FontWeight.w500,
            ),
          if (rate != null)
            AppData(
              dataLabel: rate,
              fontWeight: FontWeight.w500,
            ),
          if (quantity != null)
            AppData(
              dataLabel: quantity,
              fontWeight: FontWeight.w500,
            ),
          if (amount != null)
            AppData(
              dataLabel: amount,
              fontWeight: FontWeight.w500,
            ),
        ],
      ),
    );
  }
}
