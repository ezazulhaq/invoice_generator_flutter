// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:invoice_generator/screens/components/customer_data.dart';
import 'package:invoice_generator/screens/customer_create.dart';
import 'package:invoice_generator/widgets/app_data.dart';
import 'package:http/http.dart' as http;

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({
    Key key,
  }) : super(key: key);

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  String url = "http://localhost:8105/customer/get";

  int stateCount = 0;

  Future<List<dynamic>> getCustomerDetails(String url) async {
    http.Response dataResponse = await http.get(url);

    List<dynamic> dataStats;

    if (dataResponse.statusCode == 200) {
      String dataResp = dataResponse.body;

      dataStats = jsonDecode(dataResp);
      print(dataStats);

      stateCount = dataStats.length;
    } else {
      var dataJson = dataResponse.statusCode.toString();
      // ignore: avoid_print
      print(dataJson);
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
                                print(snapShot.data[index]['gstNo']);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerCreateForm(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}