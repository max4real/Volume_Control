package com.example.volume_control

import android.content.Context
import android.media.AudioManager
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
            when (call.method) {
                "getMediaVolumeLevel" -> {
                    val mediaVolumeLevel = getMediaVolumeLevel()
                    if (mediaVolumeLevel != -1) {
                        result.success(mediaVolumeLevel)
                    } else {
                        result.error("UNAVAILABLE", "Media volume level not available.", null)
                    }
                }
                "setMediaVolumeLevel" -> {
                    val percentage = call.argument<Int>("percentage") ?: -1
                    if (percentage in 0..100) {
                        val success = setVolumeToPercentage(percentage)
                        if (success) {
                            result.success("Volume set to $percentage%.")
                        } else {
                            result.error("FAILED", "Unable to set volume to $percentage%.", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Percentage must be between 0 and 100.", null)
                    }
                }
                "getMaxVolume" -> {
                    val maxVolume = getMaxVolume(AudioManager.STREAM_MUSIC)
                    if (maxVolume > 0) {
                        result.success(maxVolume)
                    } else {
                        result.error("UNAVAILABLE", "Max volume not available.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Volume Control Method Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VOLUME_CHANNEL).setMethodCallHandler { call, result ->
        print(call.method)
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

    /**
     * Gets the maximum volume level for the specified audio stream.
     */
    private fun getMaxVolume(streamType: Int): Int {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return audioManager.getStreamMaxVolume(streamType)
    }

    /**
     * Gets the current media volume level as a percentage (0-100).
     */
    private fun getMediaVolumeLevel(): Int {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return try {
            val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
            if (maxVolume > 0) {
                (currentVolume * 100) / maxVolume
            } else {
                -1 // Error case
            }
        } catch (e: Exception) {
            e.printStackTrace()
            -1 // Error case
        }
    }

    /**
     * Adjusts the volume up or down by one step.
     */
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

    /**
     * Sets the media volume to a specific percentage (0-100).
     */
    private fun setVolumeToPercentage(percentage: Int): Boolean {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return try {
            val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            val targetVolume = (percentage / 100.0 * maxVolume).toInt()
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, targetVolume, AudioManager.FLAG_PLAY_SOUND)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
