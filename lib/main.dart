import 'package:flutter/material.dart';
import 'package:volume_control/controls/v_controls.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      home: VolumeControlPage()
    );
  }
}
