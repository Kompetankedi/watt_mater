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

            val plugged = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1)
            when (plugged) {
                BatteryManager.BATTERY_PLUGGED_AC -> map["plugged"] = "AC"
                BatteryManager.BATTERY_PLUGGED_USB -> map["plugged"] = "USB"
                BatteryManager.BATTERY_PLUGGED_WIRELESS -> map["plugged"] = "Wireless"
                else -> map["plugged"] = "Unplugged"
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

        // Try reading common sysfs power supply nodes without root (if permission/SELinux permits)
        val sysfsFiles = listOf(
            "usb_real_type" to "/sys/class/power_supply/usb/real_type",
            "usb_real_type_qcom" to "/sys/class/qcom-battery/real_type",
            "usb_real_type_qcom2" to "/sys/class/qcom-battery/usb_real_type",
            "usb_type" to "/sys/class/power_supply/usb/type",
            "usb_type_sys" to "/sys/class/power_supply/usb/usb_type",
            "pd_active" to "/sys/class/power_supply/usb/pd_active",
            "pd_allowed" to "/sys/class/power_supply/usb/pd_allowed",
            "quick_charge_type" to "/sys/class/power_supply/usb/quick_charge_type",
            "quick_charge_type_qcom" to "/sys/class/qcom-battery/quick_charge_type",
            "hvdcp3_type" to "/sys/class/power_supply/usb/hvdcp3_type",
            "typec_mode" to "/sys/class/power_supply/usb/typec_mode",
            "typec_mode_qcom" to "/sys/class/qcom-battery/typec_mode",
            "pwr_opmode" to "/sys/class/typec/port0/pwr_opmode",
            "power_operation_mode" to "/sys/class/typec/port0/power_operation_mode",
            "charger_type" to "/sys/class/power_supply/battery/charger_type",
            "usb_charger_type" to "/sys/class/power_supply/usb/charger_type",
            "charge_type" to "/sys/class/power_supply/battery/charge_type",
            "fastcharge_mode" to "/sys/class/power_supply/battery/fastcharge_mode",
            "fastcharge_mode_qcom" to "/sys/class/qcom-battery/fastchg_mode",
            "turbo_mode" to "/sys/class/power_supply/battery/turbo_mode",
            "turbo_mode_qcom" to "/sys/class/qcom-battery/fg1_fastcharge",
            "usb_voltage_now" to "/sys/class/power_supply/usb/voltage_now",
            "usb_voltage_max" to "/sys/class/power_supply/usb/voltage_max",
            "soh" to "/sys/class/qcom-battery/soh",
            "soc_decimal" to "/sys/class/qcom-battery/soc_decimal",
            "cycle_count" to "/sys/class/power_supply/battery/cycle_count"
        )
        for ((k, path) in sysfsFiles) {
            try {
                val f = java.io.File(path)
                if (f.exists() && f.canRead()) {
                    val text = f.readText().trim()
                    if (text.isNotEmpty()) {
                        map[k] = text
                    }
                }
            } catch (_: Exception) {}
        }

        map["model"] = android.os.Build.MODEL
        map["android_ver"] = android.os.Build.VERSION.RELEASE
        map["rom"] = android.os.Build.DISPLAY

        try {
            val systemProperties = Class.forName("android.os.SystemProperties")
            val getMethod = systemProperties.getMethod("get", String::class.java, String::class.java)
            val marketName = getMethod.invoke(null, "ro.product.marketname", "") as String
            if (marketName.isNotEmpty()) {
                map["ro.product.marketname"] = marketName
            }
            val odmMarketName = getMethod.invoke(null, "ro.product.odm.marketname", "") as String
            if (odmMarketName.isNotEmpty()) {
                map["ro.product.odm.marketname"] = odmMarketName
            }
            val miIncremental = getMethod.invoke(null, "ro.mi.os.version.incremental", "") as String
            if (miIncremental.isNotEmpty()) {
                map["ro.mi.os.version.incremental"] = miIncremental
            }
            val miName = getMethod.invoke(null, "ro.mi.os.version.name", "") as String
            if (miName.isNotEmpty()) {
                map["ro.mi.os.version.name"] = miName
            }
            val buildInc = getMethod.invoke(null, "ro.build.version.incremental", "") as String
            if (buildInc.isNotEmpty()) {
                map["ro.build.version.incremental"] = buildInc
            }
        } catch (_: Exception) {}

        return map
    }
}
