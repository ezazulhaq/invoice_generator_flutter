// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_generator/constants.dart';
import 'package:invoice_generator/screens/components/product_data.dart';
import 'package:invoice_generator/screens/home.dart';
import 'package:invoice_generator/screens/product_create.dart';
import 'package:invoice_generator/screens/product_update.dart';
import 'package:invoice_generator/widgets/app_data.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    Key key,
  }) : super(key: key);

  static String id = "product_details";

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int stateCount = 0;

  Future<List<dynamic>> getProductDetails(String url) async {
    http.Response dataResponse = await http.get(Uri.parse(url));

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
      getProductDetails(kProductDetails);
    });
  }

  @override
  void initState() {
    super.initState();
    getProductDetails(kProductDetails);
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
          "Product Dashboard",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.white,
        child: FutureBuilder(
          future: getProductDetails(kProductDetails),
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
                        separatorBuilder: (context, index) => const Divider(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: ScrollController(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: ProductData(
                              particulars: snapShot.data[index]['particulars'],
                              hsnCode:
                                  snapShot.data[index]['hsnCode'].toString(),
                              rate: snapShot.data[index]['rate'].toString(),
                            ),
                            onTap: () {
                              if (snapShot.data[index]['gstNo'] != "") {
                                final refreshData = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductUpdateForm(
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
            ProductCreateForm.id,
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
