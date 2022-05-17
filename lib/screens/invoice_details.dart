// @dart=2.9
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_generator/screens/components/invoice_data.dart';
import 'package:invoice_generator/screens/home.dart';
import 'package:invoice_generator/screens/invoice_create.dart';
import 'package:invoice_generator/widgets/app_data.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({
    Key key,
  }) : super(key: key);

  static String id = "invoice_details";

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  final url = kInvoiceDetails;

  int stateCount = 0;

  Future<List<dynamic>> getInvoiceDetails(String url) async {
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
      getInvoiceDetails(url);
    });
  }

  @override
  void initState() {
    super.initState();
    getInvoiceDetails(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              InvoiceHome.id,
            );
          },
        ),
        title: const Text(
          "Invoice Dashboard",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.white,
        child: FutureBuilder(
          future: getInvoiceDetails(url),
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
                              dataLabel: "Invoice No",
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                            AppData(
                              dataLabel: "Customer Name",
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                            AppData(
                              dataLabel: "Grand Total",
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ListView.separated(
                        itemCount: stateCount,
                        separatorBuilder: (context, index) => const Divider(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: ScrollController(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: InvoiceData(
                              invoiceId:
                                  snapShot.data[index]['invoiceId'].toString(),
                              customer: snapShot.data[index]['customer'],
                              grandTotal: snapShot.data[index]['grandTotal'],
                            ),
                            onTap: () {
                              if (snapShot.data[index]['invoiceId'] != "") {
                                final refreshData = null;

                                if (refreshData != null) {
                                  _refresh();
                                }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(
            context,
            InvoiceCreateForm.id,
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
