// @dart=2.9
// ignore_for_file: unnecessary_const, avoid_print

import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:invoice_generator/controller/invoice_notifier.dart';
import 'package:invoice_generator/screens/customer_create.dart';
import 'package:invoice_generator/screens/customer_details.dart';
import 'package:invoice_generator/screens/customer_update.dart';
import 'package:invoice_generator/screens/goods_add.dart';
import 'package:invoice_generator/screens/home.dart';
import 'package:invoice_generator/screens/invoice_create.dart';
import 'package:invoice_generator/screens/invoice_details.dart';
import 'package:invoice_generator/screens/product_create.dart';
import 'package:invoice_generator/screens/product_details.dart';
import 'package:invoice_generator/screens/product_update.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InvoiceNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: InvoiceHome.id,
      routes: {
        InvoiceHome.id: (BuildContext context) => const InvoiceHome(),
        InvoiceDetailsScreen.id: (BuildContext context) =>
            const InvoiceDetailsScreen(),
        InvoiceCreateForm.id: (BuildContext context) =>
            const InvoiceCreateForm(),
        CustomerDetailsScreen.id: (BuildContext context) =>
            const CustomerDetailsScreen(),
        CustomerCreateForm.id: (BuildContext context) =>
            const CustomerCreateForm(),
        CustomerUpdateForm.id: (BuildContext context) =>
            const CustomerUpdateForm(),
        ProductDetailsScreen.id: (BuildContext context) =>
            const ProductDetailsScreen(),
        ProductCreateForm.id: (BuildContext context) =>
            const ProductCreateForm(),
        ProductUpdateForm.id: (BuildContext context) =>
            const ProductUpdateForm(),
        GoodsAddForm.id: (BuildContext context) => const GoodsAddForm(),
      },
    );
  }
}
