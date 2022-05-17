// @dart=2.9
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_generator/constants.dart';
import 'package:invoice_generator/screens/components/customer_data.dart';
import 'package:invoice_generator/screens/invoice_details.dart';
import 'package:invoice_generator/widgets/app_button.dart';
import 'package:invoice_generator/widgets/app_data.dart';

class InvoiceCreateForm extends StatefulWidget {
  const InvoiceCreateForm({
    Key key,
  }) : super(key: key);

  static String id = "invoice_create";

  @override
  State<InvoiceCreateForm> createState() => _InvoiceCreateFormState();
}

class _InvoiceCreateFormState extends State<InvoiceCreateForm> {
  final url = kCustomerDetails;

  int stateCount = 0;

  Future<List<dynamic>> getCustomerDetails(String url) async {
    http.Response dataResponse = await http.get(url);

    List<dynamic> dataStats;

    if (dataResponse.statusCode == 200) {
      String dataResp = dataResponse.body;

      dataStats = jsonDecode(dataResp);

      stateCount = dataStats.length;
    } else {
      var dataJson = dataResponse.statusCode.toString();
      if (kDebugMode) {
        print("Respose Failed - " + dataJson);
      }
    }

    return dataStats;
  }

  Future<void> _refresh() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      getCustomerDetails(url);
    });
  }

  final gstNo = TextEditingController();
  final customerName = TextEditingController();
  final address = TextEditingController();
  final state = TextEditingController();
  final phoneNumber = TextEditingController();
  final pinCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCustomerDetails(url);
  }

  @override
  void dispose() {
    gstNo.dispose();
    customerName.dispose();
    address.dispose();
    state.dispose();
    phoneNumber.dispose();
    pinCode.dispose();
    super.dispose();
  }

  Future<void> _onClickSave() async {
    Map<String, dynamic> body = {
      "customer": {
        "gstNo": gstNo.text,
        "customerName": customerName.text,
        "address": address.text,
        "state": state.text,
        "phoneNumber": phoneNumber.text,
        "pinCode": pinCode.text
      },
      "invoiceDate": null,
      "total": 0,
      "cgst": 0,
      "sgst": 0,
      "grandTotal": 0,
      "amountInWords": ""
    };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      Uri.parse(kInvoiceSave),
      headers: kHeaders,
      body: jsonBody,
      encoding: kEncoding,
    );

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Navigator.popAndPushNamed(
        context,
        InvoiceDetailsScreen.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              InvoiceDetailsScreen.id,
            );
          },
        ),
        title: const Text(
          "Invoice Create",
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
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: gstNo,
                        readOnly: true,
                        //keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter GST No',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        onPressed: () {
                          final customerData =
                              getCustomerDetailsDialog(context);

                          if (customerData != null) {
                            _refresh();
                          }
                        },
                        buttonLable: "Get",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: customerName,
                  readOnly: true,
                  //keyboardType: TextInputType.text,
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
                  readOnly: true,
                  //keyboardType: TextInputType.text,
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
                  readOnly: true,
                  //keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Customer State',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: phoneNumber,
                  readOnly: true,
                  //keyboardType: TextInputType.number,
                  //maxLength: 10,
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
                  readOnly: true,
                  //keyboardType: TextInputType.number,
                  //maxLength: 6,
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
                    _onClickSave();
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

  Future<dynamic> getCustomerDetailsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          elevation: kDefaultPadding / 2,
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: Colors.white,
            child: FutureBuilder(
              future: getCustomerDetails(url),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapShot) {
                if (snapShot.connectionState == ConnectionState.none &&
                    snapShot.hasData == null) {
                  return Container();
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                AppData(
                                  dataLabel: "GST No",
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                AppData(
                                  dataLabel: "Customer Name",
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          ListView.separated(
                            itemCount: stateCount,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            controller: ScrollController(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: CustomerData(
                                  gstNo: snapShot.data[index]['gstNo'],
                                  customerName: snapShot.data[index]
                                      ['customerName'],
                                ),
                                onTap: () {
                                  if (snapShot.data[index]['gstNo'] != "") {
                                    setState(() {
                                      gstNo.text =
                                          snapShot.data[index]['gstNo'];
                                      customerName.text =
                                          snapShot.data[index]['customerName'];
                                      address.text =
                                          snapShot.data[index]['address'];
                                      state.text =
                                          snapShot.data[index]['state'];
                                      phoneNumber.text = snapShot.data[index]
                                              ['phoneNumber']
                                          .toString();
                                      pinCode.text = snapShot.data[index]
                                              ['pinCode']
                                          .toString();
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
