import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volume_control/controls/c_control.dart';
import 'package:get/get.dart';

class VolumeControlPage extends StatelessWidget {
  const VolumeControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    VolumeControlController controller = Get.put(VolumeControlController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volume Control UI with Swipe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                controller.volumeUp();
              },
              // icon: const Icon(Icons.volume_up),
              icon: const FaIcon(
                FontAwesomeIcons.volumeHigh,
                size: 15,
              ),
              color: Colors.blue,
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                // HapticFeedback.lightImpact();
                controller.listenSwipe(details);
              },
              child: Container(
                width: 35,
                height: controller.maxVolume,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ValueListenableBuilder(
                    valueListenable: controller.volumeLevel,
                    builder: (context, volumeLevel, child) {
                      final volume = double.tryParse(volumeLevel) ?? 0;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 35,
                        height: volume,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                controller.volumeDown();
              },
              // icon: const Icon(Icons.volume_down),
              icon: const FaIcon(
                FontAwesomeIcons.volumeLow,
                size: 15,
              ),
              color: Colors.blue,
            ),
            ElevatedButton(
              onPressed: () async {
                final bool? res =
                    await FlutterOverlayWindow.requestPermission();
                print(res);
              },
              child: const Text("Request Permiaaion"),
            ),
            ElevatedButton(
              onPressed: () async {
                final status = await FlutterOverlayWindow.isPermissionGranted();
                print(status);
              },
              child: const Text("Check Permiaaion"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (await FlutterOverlayWindow.isActive()) return;
                await FlutterOverlayWindow.showOverlay(
                  enableDrag: true,
                  flag: OverlayFlag.defaultFlag,
                  visibility: NotificationVisibility.visibilityPublic,
                  positionGravity: PositionGravity.auto,
                  alignment: OverlayAlignment.centerRight,
                  height: 250,
                  width: 80,
                  startPosition: const OverlayPosition(0, -259),
                );
              },
              child: const Text("Show Overlay"),
            ),
            TextButton(
              onPressed: () {
                FlutterOverlayWindow.closeOverlay();
              },
              child: const Text("Close Overlay"),
            ),
          ],
        ),
      ),
    );
  }
}
