import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class VolumeControlController extends GetxController {
  static const volumeLevelMC = MethodChannel('samples.flutter.dev/media');
  static const volumeChannelMC = MethodChannel('samples.flutter.dev/volume');

  ValueNotifier<String> volumeLevel = ValueNotifier("0");
  final maxVolume = 150.0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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

  void listenSwipe(DragUpdateDetails details) {
    final volume = double.tryParse(volumeLevel.value) ?? 0;
    final newVolume = volume - details.delta.dy;
    if (newVolume >= 0 && newVolume <= maxVolume) {
      volumeLevel.value = newVolume.toString();
    }
  }
}