// @dart=2.9
import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';

class NavLinks extends StatelessWidget {
  const NavLinks({
    Key key,
    this.linkName,
    this.navigateTo,
  }) : super(key: key);

  final String linkName;
  final Function navigateTo;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: navigateTo,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.fromLTRB(
              kDefaultPadding, 40.0, kDefaultPadding, 40.0),
        ),
        shadowColor: MaterialStateColor.resolveWith(
          (states) => Colors.blueGrey,
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      child: Text(
        linkName,
      ),
    );
  }
}
