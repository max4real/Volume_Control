import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class VolumeControlController extends GetxController {
  static const volumeLevelMC = MethodChannel('samples.flutter.dev/media');
  static const volumeChannelMC = MethodChannel('samples.flutter.dev/volume');

  ValueNotifier<String> volumeLevel = ValueNotifier("0");
  final maxVolume = 100.0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // FlutterOverlayWindow.overlayListener.listen((event) {
    //   print("1");
    //   if (event == "volumeUp") {
    //     print("Volume Up received");
    //     volumeUp();
    //   } else if (event == "volumeDown") {
    //     print("Volume Down received");
    //     volumeDown();
    //   }
    // });
    _getMaxVolume();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // FlutterOverlayWindow.disposeOverlayListener();
  }

  Future<void> _getMaxVolume() async {
    try {
      final int maxVolume = await volumeLevelMC.invokeMethod('getMaxVolume');
      print("Max Volume: $maxVolume");
    } on PlatformException catch (e) {
      print("Failed to get max volume: '${e.message}'.");
    }
  }

  Future<void> _getMediaVolumeLevel() async {
    String mediaVolumeLevel;
    try {
      final int result =
          await volumeLevelMC.invokeMethod('getMediaVolumeLevel');
      mediaVolumeLevel = result.toString();
    } on PlatformException catch (e) {
      mediaVolumeLevel = "Failed to get media volume level: '${e.message}'.";
    }

    volumeLevel.value = mediaVolumeLevel;
  }

  Future<void> volumeUp() async {
    try {
      final result = await volumeChannelMC.invokeMethod('volumeUp');
      print(result); // Logs success message
      _getMediaVolumeLevel();
    } on PlatformException catch (e) {
      print("Failed to increase volume: '${e.message}'.");
    }
  }

  Future<void> volumeDown() async {
    try {
      final result = await volumeChannelMC.invokeMethod('volumeDown');
      print(result); // Logs success message
      _getMediaVolumeLevel();
    } on PlatformException catch (e) {
      print("Failed to decrease volume: '${e.message}'.");
    }
  }

  static Future<void> setMediaVolumeLevel(int percentage) async {
    await volumeLevelMC
        .invokeMethod('setMediaVolumeLevel', {'percentage': percentage});
  }

  void listenSwipe(DragUpdateDetails details) {
    final volume = double.tryParse(volumeLevel.value) ?? 0;
    final newVolume = volume - details.delta.dy;
    if (newVolume >= 0 && newVolume <= maxVolume) {
      volumeLevel.value = newVolume.toString();
      final volume = double.tryParse(volumeLevel.value) ?? 0;
      int intValue = volume.toInt();
      if (intValue % 10 == 0) {
        HapticFeedback.vibrate();
      }
      setMediaVolumeLevel(intValue);
    }
  }
}
