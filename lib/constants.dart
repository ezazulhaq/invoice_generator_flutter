import 'dart:convert';

import 'package:flutter/material.dart';

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);

const kDefaultPadding = 20.0;

const kCustomerDetails = "http://localhost:8105/customer/get";
const kCustomerSave = "http://localhost:8105/customer/save";

final kEncoding = Encoding.getByName('utf-8');
final kHeaders = {'Content-Type': 'application/json'};
