import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volume_control/controls/v_controls.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: () async {
                  // await FlutterOverlayWindow.shareData("volumeUp");
                  print("Sharing data: volumeUp");
                },
                icon: const FaIcon(
                  FontAwesomeIcons.volumeHigh,
                  size: 15,
                ),
                color: const Color(0XFFCAF477),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  // await FlutterOverlayWindow.shareData("volumeDown");
                  print("Sharing data: volumeDown");
                },
                icon: const FaIcon(
                  FontAwesomeIcons.volumeLow,
                  size: 15,
                ),
                color: const Color(0XFFCAF477),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: VolumeControlPage(),
    );
  }
}
