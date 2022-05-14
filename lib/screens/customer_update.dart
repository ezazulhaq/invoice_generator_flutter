// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:http/http.dart' as http;

class CustomerUpdateForm extends StatefulWidget {
  const CustomerUpdateForm({
    Key key,
    this.snapShot,
  }) : super(key: key);

  final dynamic snapShot;

  @override
  State<CustomerUpdateForm> createState() => _CustomerUpdateFormState();
}

class _CustomerUpdateFormState extends State<CustomerUpdateForm> {
  final url = kCustomerSave;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Create"),
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
                ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse(url);
                    final headers = {'Content-Type': 'application/json'};

                    Map<String, dynamic> body = {
                      "gstNo": gstNo.text,
                      "customerName": customerName.text,
                      "address": address.text,
                      "state": state.text,
                      "phoneNumber": phoneNum.text,
                      "pinCode": pinCode.text
                    };

                    print(body);

                    String jsonBody = json.encode(body);
                    final encoding = Encoding.getByName('utf-8');

                    http.Response response = await http.post(
                      uri,
                      headers: headers,
                      body: jsonBody,
                      encoding: encoding,
                    );

                    int statusCode = response.statusCode;
                    if (statusCode == 200) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: kDefaultPadding,
                    ),
                    child: Text(
                      "Update",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
