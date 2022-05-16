// @dart=2.9
import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key key,
    @required this.onPressed,
    @required this.buttonLable,
    this.color,
  }) : super(key: key);

  final Function onPressed;
  final String buttonLable;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding,
        ),
        child: Text(
          buttonLable,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
      ),
    );
  }
}
