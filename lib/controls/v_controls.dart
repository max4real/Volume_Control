import 'package:flutter/material.dart';
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
              icon: const Icon(Icons.volume_up),
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
              icon: const Icon(Icons.volume_down),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
