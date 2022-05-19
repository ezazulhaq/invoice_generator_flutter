// @dart=2.9
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:invoice_generator/screens/components/product_data.dart';
import 'package:invoice_generator/screens/invoice_update.dart';
import 'package:invoice_generator/widgets/app_button.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_generator/widgets/app_data.dart';

class GoodsAddForm extends StatefulWidget {
  const GoodsAddForm({
    Key key,
    this.invoiceId,
  }) : super(key: key);

  static String id = "good_add";

  final String invoiceId;

  @override
  State<GoodsAddForm> createState() => _GoodsAddFormState();
}

class _GoodsAddFormState extends State<GoodsAddForm> {
  dynamic mapInvoice;

  final invoiceID = TextEditingController();
  final productId = TextEditingController();
  final particulars = TextEditingController();
  final hsnCode = TextEditingController();
  final rate = TextEditingController();
  final kg = TextEditingController();
  final amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    invoiceID.text = widget.invoiceId;

    _getInvoiceFromId(kInvoiceFromId + invoiceID.text);
  }

  @override
  void dispose() {
    invoiceID.dispose();
    productId.dispose();
    particulars.dispose();
    hsnCode.dispose();
    rate.dispose();
    kg.dispose();
    amount.dispose();
    super.dispose();
  }

  Future<void> _getInvoiceFromId(String url) async {
    var client = http.Client();
    try {
      var dataResponse = await client.get(Uri.parse(url));

      if (dataResponse.statusCode == 200) {
        String dataResp = dataResponse.body;

        mapInvoice = jsonDecode(dataResp);
      } else {
        var dataJson = dataResponse.statusCode.toString();
        if (kDebugMode) {
          print("Respose Failed - " + dataJson);
        }
      }
    } finally {
      client.close();
    }
  }

  int stateCount = 0;

  Future<List<dynamic>> _getProductDetails(String url) async {
    var client = http.Client();
    List<dynamic> dataStats;

    try {
      var dataResponse = await client.get(Uri.parse(url));

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
    } finally {
      client.close();
    }

    return dataStats;
  }

  Future<void> _refresh() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      _getProductDetails(kProductDetails);
    });
  }

  Future<void> _onClickAdd() async {
    Map<String, dynamic> body = {
      "invoice": mapInvoice,
      "product": {
        "id": productId.text,
        "particulars": particulars.text,
        "hsnCode": hsnCode.text,
        "rate": rate.text
      },
      "kgs": kg.text,
      "amount": amount.text
    };

    if (kDebugMode) {
      print("Map Details - " + body.toString());
    }

    String jsonBody = jsonEncode(body);
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.parse(kGoodSave),
        headers: kHeaders,
        body: jsonBody,
        encoding: kEncoding,
      );

      if (response.statusCode == 200) {
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => InvoiceUpdateForm(
              snapShot: mapInvoice,
            ),
          ),
        );
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Goods",
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
                        controller: particulars,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Product Name',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding / 2,
                    ),
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        onPressed: () {
                          final customerData = getProductDetailsDialog(context);

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
                  controller: hsnCode,
                  readOnly: true,
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
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Rate',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: kg,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Kgs',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                TextField(
                  controller: amount,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Amount',
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                AppButton(
                  onPressed: () {
                    setState(() {
                      amount.text =
                          (double.parse(rate.text) * double.parse(kg.text))
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
                    _onClickAdd();
                  },
                  buttonLable: "Add",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> getProductDetailsDialog(BuildContext context) {
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
              future: _getProductDetails(kProductDetails),
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
                                  dataLabel: "Particulars",
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                AppData(
                                  dataLabel: "HSN Code",
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                AppData(
                                  dataLabel: "Rate",
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
                                child: ProductData(
                                  particulars: snapShot.data[index]
                                      ['particulars'],
                                  hsnCode: snapShot.data[index]['hsnCode']
                                      .toString(),
                                  rate: snapShot.data[index]['rate'].toString(),
                                ),
                                onTap: () {
                                  if (snapShot.data[index]['id'] != "") {
                                    setState(() {
                                      productId.text =
                                          snapShot.data[index]['id'].toString();
                                      particulars.text =
                                          snapShot.data[index]['particulars'];
                                      hsnCode.text = snapShot.data[index]
                                              ['hsnCode']
                                          .toString();
                                      rate.text = snapShot.data[index]['rate']
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
