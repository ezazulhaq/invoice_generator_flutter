// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);

const kDefaultPadding = 20.0;

Map<String, String> kHeaders = {'Content-Type': 'application/json'};
Encoding kEncoding = Encoding.getByName('utf-8');

const kCustomerDetails = "http://10.0.2.2:8105/customer/get";
const kCustomerSave = "http://10.0.2.2:8105/customer/save";
const kCustomerRemove = "http://10.0.2.2:8105/customer/remove/";

const kProductDetails = "http://10.0.2.2:8105/product/get";
const kProductSave = "http://10.0.2.2:8105/product/save";
const kProductRemove = "http://10.0.2.2:8105/product/remove/";

const kInvoiceDetails = "http://10.0.2.2:8105/invoice/get";
const kInvoiceSave = "http://10.0.2.2:8105/invoice/save";
const kInvoiceFromId = "http://10.0.2.2:8105/invoice/get/";

const kGoodSave = "http://10.0.2.2:8105/good/save";
const kGoodFromInvoiceId = "http://10.0.2.2:8105/good/get/invoice/";
