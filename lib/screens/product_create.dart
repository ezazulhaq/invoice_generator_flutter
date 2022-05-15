// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_generator/constants.dart';
import 'package:invoice_generator/widgets/app_button.dart';

class ProductCreateForm extends StatefulWidget {
  const ProductCreateForm({Key key}) : super(key: key);

  @override
  State<ProductCreateForm> createState() => _ProductCreateFormState();
}

class _ProductCreateFormState extends State<ProductCreateForm> {
  final particulars = TextEditingController();
  final hsnCode = TextEditingController();
  final rate = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    particulars.dispose();
    hsnCode.dispose();
    rate.dispose();
    super.dispose();
  }

  Future<void> _onClick() async {
    Map<String, dynamic> body = {
      "particulars": particulars.text,
      "hsnCode": hsnCode.text,
      "rate": rate.text
    };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      Uri.parse(kProductSave),
      headers: kHeaders,
      body: jsonBody,
      encoding: kEncoding,
    );

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Create"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: particulars,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Product Name',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: hsnCode,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter HSN Code',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: rate,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Rate',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                AppButton(
                  onPressed: () {
                    _onClick();
                  },
                  buttonLable: "Save",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
