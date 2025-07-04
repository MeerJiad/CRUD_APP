import 'package:device_preview/device_preview.dart';

import 'package:flutter/material.dart';
import 'package:untitled8/app.dart';

void main() {
  runApp(DevicePreview(
    builder: (context) => const CRUDApp(),
    enabled: false,
  ));
}
