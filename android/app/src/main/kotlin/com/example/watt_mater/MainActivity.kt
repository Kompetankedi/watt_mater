package com.example.watt_mater

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.watt_mater/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryTemperature") {
                val temp = getBatteryTemperature()
                if (temp != null) {
                    result.success(temp)
                } else {
                    result.error("UNAVAILABLE", "Battery temperature not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryTemperature(): Double? {
        val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val temp = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
        if (temp == -1) return null
        return temp / 10.0
    }
}
