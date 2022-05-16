// @dart=2.9
import 'package:flutter/material.dart';
import 'package:invoice_generator/constants.dart';
import 'package:invoice_generator/screens/customer_details.dart';
import 'package:invoice_generator/screens/product_details.dart';
import 'package:invoice_generator/widgets/nav_links.dart';

class InvoiceHome extends StatelessWidget {
  const InvoiceHome({
    Key key,
  }) : super(key: key);

  static String id = "invoice_home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NavLinks(
                linkName: "Invoice Details",
                navigateTo: () {
                  print("Invoice Details");
                },
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              NavLinks(
                linkName: "Customer Details",
                navigateTo: () {
                  Navigator.popAndPushNamed(
                    context,
                    CustomerDetailsScreen.id,
                  );
                },
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              NavLinks(
                linkName: "Product Details",
                navigateTo: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductDetailsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
