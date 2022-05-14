// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerServices {
  Future<void> saveUpdateCustomer(BuildContext context, dynamic url,
      Map<String, String> headers, dynamic body, Encoding encoding) async {
    final uri = Uri.parse(url);

    String jsonBody = json.encode(body);

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
  }
}
