import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volume_control/controls/c_control.dart';
import 'package:volume_control/controls/v_controls.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(VolumeControlController());
  runApp(const MainApp());
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(VolumeControlController());
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayPage(),
    ),
  );
}

class OverlayPage extends StatelessWidget {
  const OverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    // VolumeControlController controller = Get.find();
    return Scaffold(
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
                print("Sharing data: volumeUp");
                // controller.test();
                await FlutterOverlayWindow.shareData("volumeUp");
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
                print("Sharing data: volumeDown");
                await FlutterOverlayWindow.shareData("volumeDown");
              },
              icon: const FaIcon(
                FontAwesomeIcons.volumeLow,
                size: 15,
              ),
              color: const Color(0XFFCAF477),
            ),
            IconButton(
              onPressed: () async {},
              icon: const FaIcon(
                FontAwesomeIcons.ellipsis,
                size: 15,
              ),
              color: const Color(0XFFCAF477),
            ),
          ],
        ),
      ),
    );
  }
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
