import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volume_control/controls/c_control.dart';
import 'package:get/get.dart';

class VolumeControlPage extends StatefulWidget {
  const VolumeControlPage({super.key});

  @override
  State<VolumeControlPage> createState() => _VolumeControlPageState();
}

class _VolumeControlPageState extends State<VolumeControlPage> {
  VolumeControlController controller = Get.find();
  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    FlutterOverlayWindow.closeOverlay();
    super.dispose();
  }

  void initLoad() async {
    // if (await FlutterOverlayWindow.isActive()) return;
    // await FlutterOverlayWindow.showOverlay(
    //   enableDrag: true,
    //   flag: OverlayFlag.defaultFlag,
    //   visibility: NotificationVisibility.visibilityPublic,
    //   positionGravity: PositionGravity.auto,
    //   alignment: OverlayAlignment.centerRight,
    //   height: 300,
    //   width: 80,
    //   startPosition: const OverlayPosition(0, -259),
    // );
    // print('done init');
    // FlutterOverlayWindow.overlayListener.listen((event) {
    //   print(event);
    //   if (event != null) {
    //     // print("Event received: $event");
    //     switch (event) {
    //       case "volumeUp":
    //         // print("Volume Up triggered");
    //         controller.volumeUp();
    //         break;
    //       case "volumeDown":
    //         // print("Volume Down triggered");
    //         controller.volumeDown();
    //         break;
    //       default:
    //         // print("Unknown event: $event");
    //     }
    //   } else {
    //     print("No event received");
    //   }
    // });
  }
  @override
  Widget build(BuildContext context) {
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
                        bool isHighVolume = volume > 95;
                        bool isLowVolume = volume < 5;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isLowVolume ? (volume / 10) + 25 : 35,
                          height: volume,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(8),
                              bottomRight: const Radius.circular(8),
                              topLeft: isHighVolume
                                  ? const Radius.circular(8)
                                  : Radius.zero,
                              topRight: isHighVolume
                                  ? const Radius.circular(8)
                                  : Radius.zero,
                            ),
                          ),
                        );
                      },
                    )),
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
                  height: 300,
                  width: 80,
                  startPosition: const OverlayPosition(0, -259),
                );
              },
              child: const Text("Show Overlay"),
            ),
            TextButton(
              onPressed: () {
                // FlutterOverlayWindow.shareData('hello');
                FlutterOverlayWindow.closeOverlay();
                FlutterOverlayWindow.disposeOverlayListener();
              },
              child: const Text("Close Overlay"),
            ),
            TextButton(
              onPressed: () {
                FlutterOverlayWindow.shareData('hello');
              },
              child: const Text("send"),
            ),
          ],
        ),
      ),
    );
  }
}
