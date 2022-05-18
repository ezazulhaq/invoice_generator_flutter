// @dart=2.9
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_generator/controller/invoice_notifier.dart';
import 'package:invoice_generator/screens/components/customer_data.dart';
import 'package:invoice_generator/screens/goods_add.dart';
import 'package:invoice_generator/screens/invoice_details.dart';
import 'package:invoice_generator/widgets/app_button.dart';
import 'package:invoice_generator/widgets/app_data.dart';
import 'package:provider/provider.dart';

class InvoiceUpdateForm extends StatefulWidget {
  const InvoiceUpdateForm({
    Key key,
    this.snapShot,
  }) : super(key: key);

  static String id = "invoice_update";

  final dynamic snapShot;

  @override
  State<InvoiceUpdateForm> createState() => _InvoiceUpdateFormState();
}

class _InvoiceUpdateFormState extends State<InvoiceUpdateForm> {
  int stateCount = 0;

  Future<List<dynamic>> _getCustomerDetails(String url) async {
    http.Response dataResponse = await http.get(Uri.parse(url));

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
      _getCustomerDetails(kCustomerDetails);
    });
  }

  Future<dynamic> _getInvoiceFromId(String url) async {
    http.Response dataResponse =
        await http.get(Uri.parse(url + invoiceId.text.toString()));

    dynamic dataStats;

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

  final invoiceId = TextEditingController();
  final gstNo = TextEditingController();
  final customerName = TextEditingController();
  final address = TextEditingController();
  final state = TextEditingController();
  final phoneNumber = TextEditingController();
  final pinCode = TextEditingController();
  final invoiceDate = TextEditingController();
  final total = TextEditingController();
  final cgst = TextEditingController();
  final cgstAmt = TextEditingController();
  final sgst = TextEditingController();
  final sgstAmt = TextEditingController();
  final grandTotal = TextEditingController();
  final amountInWords = TextEditingController();

  @override
  void initState() {
    super.initState();
    invoiceId.text = widget.snapShot['invoiceId'].toString();
    gstNo.text = widget.snapShot['customer']['gstNo'];
    customerName.text = widget.snapShot['customer']['customerName'];
    address.text = widget.snapShot['customer']['address'];
    state.text = widget.snapShot['customer']['state'];
    phoneNumber.text = widget.snapShot['customer']['phoneNumber'].toString();
    pinCode.text = widget.snapShot['customer']['pinCode'].toString();
    invoiceDate.text = widget.snapShot['invoiceDate'].toString();
    total.text = widget.snapShot['total'].toString();
    cgst.text = widget.snapShot['cgst'].toString();
    cgstAmt.text =
        (widget.snapShot['total'] * widget.snapShot['cgst'] / 100).toString();
    sgst.text = widget.snapShot['sgst'].toString();
    sgstAmt.text =
        (widget.snapShot['total'] * widget.snapShot['sgst'] / 100).toString();
    grandTotal.text = widget.snapShot['grandTotal'].toString();
    amountInWords.text = widget.snapShot['amountInWords'];
    _getCustomerDetails(kCustomerDetails);
    _getInvoiceFromId(kInvoiceFromId);
  }

  @override
  void dispose() {
    invoiceId.dispose();
    gstNo.dispose();
    customerName.dispose();
    address.dispose();
    state.dispose();
    phoneNumber.dispose();
    pinCode.dispose();
    invoiceDate.dispose();
    total.dispose();
    cgst.dispose();
    cgstAmt.dispose();
    sgst.dispose();
    sgstAmt.dispose();
    grandTotal.dispose();
    amountInWords.dispose();
    super.dispose();
  }

  Future<void> _onClickUpdate() async {
    Map<String, dynamic> body = {
      "invoiceId": invoiceId.text,
      "customer": {
        "gstNo": gstNo.text,
        "customerName": customerName.text,
        "address": address.text,
        "state": state.text,
        "phoneNumber": phoneNumber.text,
        "pinCode": pinCode.text
      },
      "invoiceDate": invoiceDate.text,
      "total": total.text,
      "cgst": cgst.text,
      "sgst": sgst.text,
      "grandTotal": grandTotal.text,
      "amountInWords": amountInWords.text
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
        title: const Text(
          "Invoice Update",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: invoiceId,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Invoice No',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: gstNo,
                        readOnly: true,
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Customer Name',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: total,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Goods Total',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: cgst,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter CGST %',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding / 2,
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: cgstAmt,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter CGST %',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: sgst,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter SGST %',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding / 2,
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: sgstAmt,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter SGST %',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: grandTotal,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Grand Total',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                AppButton(
                  onPressed: () {
                    setState(() {
                      double varTotal = double.parse(total.text);
                      double varCgst = double.parse(cgst.text);
                      double varSgst = double.parse(sgst.text);
                      grandTotal.text = ((varTotal * varCgst) / 100 +
                              (varTotal * varSgst) / 100)
                          .toString();
                    });
                  },
                  buttonLable: "Calculate",
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                AppButton(
                  onPressed: () {
                    _onClickUpdate();
                  },
                  buttonLable: "Update",
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoodsAddForm(
                invoiceId: invoiceId.text,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
        backgroundColor: Colors.redAccent,
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
              future: _getCustomerDetails(kCustomerDetails),
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
