package com.example.volume_control

import android.content.Context
import android.media.AudioManager
import android.os.BatteryManager
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val MEDIA_CHANNEL = "samples.flutter.dev/media"
    private val VOLUME_CHANNEL = "samples.flutter.dev/volume"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Media Volume Level Method Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getMediaVolumeLevel") {
                val mediaVolumeLevel = getMediaVolumeLevel()
                if (mediaVolumeLevel != -1) {
                    result.success(mediaVolumeLevel)
                } else {
                    result.error("UNAVAILABLE", "Media volume level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Volume Control Method Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VOLUME_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "volumeUp" -> {
                    val success = adjustVolume(up = true)
                    if (success) {
                        result.success("Volume increased successfully.")
                    } else {
                        result.error("UNAVAILABLE", "Unable to increase volume.", null)
                    }
                }
                "volumeDown" -> {
                    val success = adjustVolume(up = false)
                    if (success) {
                        result.success("Volume decreased successfully.")
                    } else {
                        result.error("UNAVAILABLE", "Unable to decrease volume.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getMediaVolumeLevel(): Int {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

        var maxVolume: Int
        var currentVolume: Int

        // Try to get the volume for STREAM_MUSIC (media)
        try {
            maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
        } catch (e: Exception) {
            // In case STREAM_MUSIC is not available, fallback to STREAM_RING or another stream
            maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_RING)
            currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_RING)
        }

        return if (maxVolume > 0) {
            (currentVolume * 100) / maxVolume 
        } else {
            -1 
        }
    }


    
    // Method to adjust volume up or down
    private fun adjustVolume(up: Boolean): Boolean {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return try {
            if (up) {
                audioManager.adjustVolume(AudioManager.ADJUST_RAISE, AudioManager.FLAG_PLAY_SOUND)
            } else {
                audioManager.adjustVolume(AudioManager.ADJUST_LOWER, AudioManager.FLAG_PLAY_SOUND)
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
