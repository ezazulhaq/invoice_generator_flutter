// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_generator/screens/customer_details.dart';
import 'package:invoice_generator/widgets/app_button.dart';

class CustomerUpdateForm extends StatefulWidget {
  const CustomerUpdateForm({
    Key key,
    this.snapShot,
  }) : super(key: key);

  static String id = "customer_update";

  final dynamic snapShot;

  @override
  State<CustomerUpdateForm> createState() => _CustomerUpdateFormState();
}

class _CustomerUpdateFormState extends State<CustomerUpdateForm> {
  final gstNo = TextEditingController();
  final customerName = TextEditingController();
  final address = TextEditingController();
  final state = TextEditingController();
  final phoneNum = TextEditingController();
  final pinCode = TextEditingController();

  @override
  void initState() {
    gstNo.text = widget.snapShot['gstNo'];
    customerName.text = widget.snapShot['customerName'];
    address.text = widget.snapShot['address'];
    state.text = widget.snapShot['state'];
    phoneNum.text = widget.snapShot['phoneNumber'].toString();
    pinCode.text = widget.snapShot['pinCode'].toString();
    super.initState();
  }

  @override
  void dispose() {
    gstNo.dispose();
    customerName.dispose();
    address.dispose();
    state.dispose();
    phoneNum.dispose();
    pinCode.dispose();
    super.dispose();
  }

  Future<void> _onClick() async {
    Map<String, dynamic> body = {
      "gstNo": gstNo.text,
      "customerName": customerName.text,
      "address": address.text,
      "state": state.text,
      "phoneNumber": phoneNum.text,
      "pinCode": pinCode.text
    };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      Uri.parse(kCustomerSave),
      headers: kHeaders,
      body: jsonBody,
      encoding: kEncoding,
    );

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Navigator.popAndPushNamed(
        context,
        CustomerDetailsScreen.id,
      );
    }
  }

  Future<void> _onClickDelete() async {
    String url = kCustomerRemove + gstNo.text;
    http.Response response = await http.get(
      Uri.parse(url),
    );

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Navigator.popAndPushNamed(
        context,
        CustomerDetailsScreen.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Update",
        ),
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
                  controller: gstNo,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter GST No',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: customerName,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Customer Name',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: address,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Customer Address',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: state,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Customer State',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: phoneNum,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Phone Number',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: pinCode,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Pincode',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                AppButton(
                  onPressed: () {
                    _onClick();
                  },
                  buttonLable: "Update",
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                AppButton(
                  onPressed: () {
                    _onClickDelete();
                  },
                  buttonLable: "Delete",
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
