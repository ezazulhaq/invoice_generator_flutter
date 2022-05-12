// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:http/http.dart' as http;

class CustomerCreateForm extends StatefulWidget {
  const CustomerCreateForm({Key key}) : super(key: key);

  @override
  State<CustomerCreateForm> createState() => _CustomerCreateFormState();
}

class _CustomerCreateFormState extends State<CustomerCreateForm> {
  final url = kCustomerSave;

  final gstNo = TextEditingController();
  final customerName = TextEditingController();
  final address = TextEditingController();
  final state = TextEditingController();
  final phoneNum = TextEditingController();
  final pinCode = TextEditingController();

  @override
  void initState() {
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
                      Navigator.pop(context);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: kDefaultPadding,
                    ),
                    child: Text(
                      "Save",
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
