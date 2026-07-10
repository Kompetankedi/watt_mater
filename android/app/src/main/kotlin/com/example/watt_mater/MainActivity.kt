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
            when (call.method) {
                "getBatteryTemperature" -> {
                    val temp = getBatteryTemperature()
                    if (temp != null) {
                        result.success(temp)
                    } else {
                        result.error("UNAVAILABLE", "Battery temperature not available.", null)
                    }
                }
                "getBatteryStats" -> {
                    val stats = getBatteryStats()
                    result.success(stats)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getBatteryTemperature(): Double? {
        val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val temp = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
        if (temp == -1) return null
        return temp / 10.0
    }

    private fun getBatteryStats(): Map<String, String> {
        val map = mutableMapOf<String, String>()
        val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))

        if (intent != null) {
            val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            if (level != -1 && scale != -1) {
                val batteryPct = level * 100 / scale.toFloat()
                map["capacity"] = batteryPct.toInt().toString()
            }

            val voltage = intent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1)
            if (voltage != -1) { // in mV
                map["voltage"] = (voltage * 1000).toString() // microvolts için çarpıyoruz, dart tarafı uyumlu
            }

            val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
            when (status) {
                BatteryManager.BATTERY_STATUS_CHARGING -> map["status"] = "Charging"
                BatteryManager.BATTERY_STATUS_DISCHARGING -> map["status"] = "Discharging"
                BatteryManager.BATTERY_STATUS_FULL -> map["status"] = "Full"
                BatteryManager.BATTERY_STATUS_NOT_CHARGING -> map["status"] = "Not charging"
                else -> map["status"] = "Unknown"
            }

            val temp = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)
            if (temp != -1) {
                map["batt_temp"] = temp.toString() 
            }
        }

        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        
        val currentNow = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
        map["current"] = currentNow.toString()
        
        val chargeCounter = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER) // microAmpere-hours
        if (chargeCounter > 0) {
            map["charge_full"] = chargeCounter.toString()
        }

        map["model"] = android.os.Build.MODEL
        map["android_ver"] = android.os.Build.VERSION.RELEASE
        map["rom"] = android.os.Build.DISPLAY

        return map
    }
}
