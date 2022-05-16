// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:invoice_generator/screens/components/customer_data.dart';
import 'package:invoice_generator/screens/customer_create.dart';
import 'package:invoice_generator/screens/customer_update.dart';
import 'package:invoice_generator/screens/home.dart';
import 'package:invoice_generator/widgets/app_data.dart';
import 'package:http/http.dart' as http;

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({
    Key key,
  }) : super(key: key);

  static String id = "customer_details";

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
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
      // ignore: avoid_print
      print("Respose Failed - " + dataJson);
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

  @override
  void initState() {
    super.initState();
    getCustomerDetails(url);
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
          "Customer Dashboard",
        ),
      ),
      body: RefreshIndicator(
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
                            AppData(
                              dataLabel: "Address",
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
                            child: CustomerData(
                              gstNo: snapShot.data[index]['gstNo'],
                              customerName: snapShot.data[index]
                                  ['customerName'],
                              address: snapShot.data[index]['address'],
                            ),
                            onTap: () {
                              if (snapShot.data[index]['gstNo'] != "") {
                                final refreshData = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomerUpdateForm(
                                      snapShot: snapShot.data[index],
                                    ),
                                  ),
                                );

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
            CustomerCreateForm.id,
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
