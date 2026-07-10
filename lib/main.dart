import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsManager.init();
  runApp(const WattMeterApp());
}

class LanguageManager {
  static final ValueNotifier<String> localeNotifier = ValueNotifier('en');

  static String get currentLocale => localeNotifier.value;

  static void setLocale(String locale) {
    localeNotifier.value = locale;
  }

  static String translate(String key, [List<String>? args]) {
    final translations = _localizedValues[localeNotifier.value] ?? _localizedValues['tr']!;
    var value = translations[key] ?? key;
    if (args != null && args.isNotEmpty) {
      for (var arg in args) {
        value = value.replaceFirst('{}', arg);
      }
    }
    return value;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'tr': {
      'app_title': 'Watt Mater',
      'how_to_continue': 'Nasıl devam etmek istersiniz?',
      'rooted_mode': 'Rootlu Kullanım (Tam Kontrol)',
      'rootless_mode': 'Rootsuz Kullanım (Sınırlı Veri)',
      'checking_root': 'Root İzni Kontrol Ediliyor...',
      'root_required': 'Root İzni Gerekli',
      'root_required_desc': 'Watt Mater uygulamasının pil donanım bilgilerine erişebilmesi için root yetkisine ihtiyacı vardır. Lütfen Magisk veya KernelSU üzerinden izin verin.',
      'retry_root': 'Root İzni İste / Tekrar Dene',
      'root_active': 'ROOT AKTİF',
      'rootless_active': 'ROOTSUZ MOD',
      'charge_watt': 'ŞARJ WATT',
      'discharge_watt': 'DEŞARJ WATT',
      'current_charge': 'Akım (Şarj)',
      'current_discharge': 'Akım (Deşarj)',
      'voltage': 'Voltaj',
      'capacity': 'Kapasite',
      'charge_percentage': 'Doluluk',
      'unknown': 'Bilinmiyor',
      'battery_temp': 'Pil Sıcaklığı',
      'charge_time_est': 'Şarj Süresi Tahmini',
      'full': 'Tam dolu',
      'almost_full': 'Neredeyse doldu',
      'not_charging': 'Şarjda değil',
      'cannot_calculate': 'Hesaplanamıyor',
      'full_in_mins': '{} dk sonra tam dolu',
      'battery_health': 'Pil Sağlığı / Ömrü',
      'device_info': 'Cihaz Bilgileri',
      'model': 'Model',
      'android_version': 'Android Sürümü',
      'rom_version': 'ROM Sürümü',
      'charge_limiter': 'Şarj Hızı Sınırlandırıcı (Beta)',
      'manual_ma': 'Manuel (mA)',
      'example_ma': 'Örn: 2000',
      'apply': 'UYGULA',
      'quick_limits': 'Hızlı Limitler (Watt değerine göre tahmini):',
      'reset': 'SIFIRLA',
      'limit_reset_msg': 'Şarj Sınırı Sıfırlandı',
      'limit_set_msg': 'Sınır {} mA olarak ayarlandı',
      'limit_watt_set_msg': 'Sınır {}W (~{} mA) olarak ayarlandı',
      'settings': 'Ayarlar',
      'language': 'Dil',
      'working_mode': 'Çalışma Modu',
      'save': 'Kaydet',
      'mode_changed_msg': 'Çalışma modu değiştirildi, uygulama güncelleniyor',
      'root_status_not_found': 'Root izni alınamadı, rootsuz moda geçiliyor.',
      'turkish': 'Türkçe',
      'english': 'English',
      'rooted': 'Rootlu',
      'rootless': 'Rootsuz',
      'close': 'Kapat',
      'active': 'Aktif',
      'inactive': 'Aktif Değil',
      'select_language': 'Dil Seçin',
      'select_language_desc': 'Devam etmek için bir dil seçin',
      'continue_btn': 'Devam Et',
    },
    'en': {
      'app_title': 'Watt Meter',
      'how_to_continue': 'How would you like to continue?',
      'rooted_mode': 'Rooted Mode (Full Control)',
      'rootless_mode': 'Rootless Mode (Limited Data)',
      'checking_root': 'Checking Root Access...',
      'root_required': 'Root Access Required',
      'root_required_desc': 'Watt Meter needs root access to access battery hardware information. Please grant permission via Magisk or KernelSU.',
      'retry_root': 'Request Root Access / Retry',
      'root_active': 'ROOT ACTIVE',
      'rootless_active': 'ROOTLESS MODE',
      'charge_watt': 'CHARGE WATT',
      'discharge_watt': 'DISCHARGE WATT',
      'current_charge': 'Current (Charging)',
      'current_discharge': 'Current (Discharging)',
      'voltage': 'Voltage',
      'capacity': 'Capacity',
      'charge_percentage': 'Level',
      'unknown': 'Unknown',
      'battery_temp': 'Battery Temperature',
      'charge_time_est': 'Remaining Time Est.',
      'full': 'Fully charged',
      'almost_full': 'Almost full',
      'not_charging': 'Not charging',
      'cannot_calculate': 'Cannot calculate',
      'full_in_mins': 'Fully charged in {} mins',
      'battery_health': 'Battery Health / Lifespan',
      'device_info': 'Device Information',
      'model': 'Model',
      'android_version': 'Android Version',
      'rom_version': 'ROM Version',
      'charge_limiter': 'Charging Speed Limiter (Beta)',
      'manual_ma': 'Manual (mA)',
      'example_ma': 'E.g.: 2000',
      'apply': 'APPLY',
      'quick_limits': 'Quick Limits (Estimated by Watt value):',
      'reset': 'RESET',
      'limit_reset_msg': 'Charge Limit Reset',
      'limit_set_msg': 'Limit set to {} mA',
      'limit_watt_set_msg': 'Limit set to {}W (~{} mA)',
      'settings': 'Settings',
      'language': 'Language',
      'working_mode': 'Working Mode',
      'save': 'Save',
      'mode_changed_msg': 'Working mode changed, updating app',
      'root_status_not_found': 'Root permission not granted, switching to rootless mode.',
      'turkish': 'Turkish',
      'english': 'English',
      'rooted': 'Rooted',
      'rootless': 'Rootless',
      'close': 'Close',
      'active': 'Active',
      'inactive': 'Inactive',
      'select_language': 'Select Language',
      'select_language_desc': 'Choose a language to continue',
      'continue_btn': 'Continue',
    }
  };
}

String tr(String key, [List<String>? args]) => LanguageManager.translate(key, args);

class SettingsManager {
  static late SharedPreferences _prefs;
  static final ValueNotifier<String?> workingModeNotifier = ValueNotifier(null);
  /// true = language selection screen was completed
  static final ValueNotifier<bool> languageSelectedNotifier = ValueNotifier(false);
  /// true = root check passed; used by AppHomeRouter to show Dashboard(isRooted:true)
  static final ValueNotifier<bool> rootConfirmedNotifier = ValueNotifier(false);

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Default language is English; only override if user has explicitly saved one
    final lang = _prefs.getString('language') ?? 'en';
    LanguageManager.setLocale(lang);
    languageSelectedNotifier.value = _prefs.getBool('language_selected') ?? false;
    workingModeNotifier.value = _prefs.getString('working_mode');
    // rootConfirmed is session-only — never persisted
    rootConfirmedNotifier.value = false;
  }

  static String get language => LanguageManager.currentLocale;
  static String? get workingMode => workingModeNotifier.value;

  static Future<void> setLanguage(String lang) async {
    await _prefs.setString('language', lang);
    await _prefs.setBool('language_selected', true);
    LanguageManager.setLocale(lang);
    languageSelectedNotifier.value = true;
  }

  static Future<void> setWorkingMode(String? mode) async {
    // When working mode changes, reset root confirmation
    rootConfirmedNotifier.value = false;
    if (mode == null || mode.isEmpty) {
      await _prefs.remove('working_mode');
      workingModeNotifier.value = null;
    } else {
      await _prefs.setString('working_mode', mode);
      workingModeNotifier.value = mode;
    }
  }

  static void confirmRoot() {
    rootConfirmedNotifier.value = true;
  }
}

/// Central router — all screen transitions flow through here reactively.
/// This ensures that changing settings (language / mode) always reflects
/// immediately without stale Navigator stack entries.
class AppHomeRouter extends StatelessWidget {
  const AppHomeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SettingsManager.languageSelectedNotifier,
      builder: (context, langSelected, _) {
        if (!langSelected) {
          return const LanguageSelectionScreen();
        }
        return ValueListenableBuilder<String?>(
          valueListenable: SettingsManager.workingModeNotifier,
          builder: (context, mode, _) {
            if (mode == null || mode.isEmpty) {
              return const ModeSelectionScreen();
            } else if (mode == 'rootless') {
              return const DashboardScreen(isRooted: false);
            } else {
              // mode == 'rooted'
              return ValueListenableBuilder<bool>(
                valueListenable: SettingsManager.rootConfirmedNotifier,
                builder: (context, rootConfirmed, _) {
                  if (rootConfirmed) {
                    return const DashboardScreen(isRooted: true);
                  }
                  return const RootCheckScreen();
                },
              );
            }
          },
        );
      },
    );
  }
}

class WattMeterApp extends StatelessWidget {
  const WattMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageManager.localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          title: tr('app_title'),
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF38BDF8),
              secondary: Color(0xFF818CF8),
              surface: Color(0xFF1E293B),
            ),
            fontFamily: 'Roboto',
          ),
          home: const AppHomeRouter(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class RootService {
  static Future<bool> hasRoot() async {
    try {
      final result = await Process.run('su', ['-c', 'id']);
      return result.stdout.toString().contains('uid=0');
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, String>> fetchStats() async {
    const script = r'''
#!/system/bin/sh
getprop
echo "---BATTERY---"
echo "capacity=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo '0')"
echo "voltage=$(cat /sys/class/power_supply/battery/voltage_now 2>/dev/null || echo '0')"
echo "current=$(cat /sys/class/power_supply/battery/current_now 2>/dev/null || echo '0')"
echo "charge_full=$(cat /sys/class/power_supply/bms/charge_full 2>/dev/null || cat /sys/class/power_supply/battery/charge_full 2>/dev/null || echo '0')"
echo "charge_full_design=$(cat /sys/class/power_supply/bms/charge_full_design 2>/dev/null || cat /sys/class/power_supply/battery/charge_full_design 2>/dev/null || echo '0')"
echo "status=$(cat /sys/class/power_supply/battery/status 2>/dev/null || echo 'Unknown')"
echo "batt_temp=$(cat /sys/class/power_supply/battery/temp 2>/dev/null || echo '0')"
ZONE=$(grep -li 'cpu' /sys/class/thermal/thermal_zone*/type 2>/dev/null | head -n 1)
if [ -n "$ZONE" ]; then
  TEMP_FILE=$(echo "$ZONE" | sed 's/type/temp/')
  echo "cpu_temp=$(cat "$TEMP_FILE" 2>/dev/null || echo '0')"
else
  echo "cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo '0')"
fi

for tz in /sys/class/thermal/thermal_zone*; do
  if [ -d "$tz" ]; then
    type=$(cat "$tz/type" 2>/dev/null)
    temp=$(cat "$tz/temp" 2>/dev/null)
    if [ -n "$type" ] && [ -n "$temp" ]; then
      tz_num=$(basename "$tz" | sed 's/thermal_zone//')
      echo "tz_${type}_${tz_num}=${temp}"
    fi
  fi
done
''';
    try {
      final result = await Process.run('su', ['-c', script]);
      final lines = result.stdout.toString().split('\n');
      final map = <String, String>{};
      for (var l in lines) {
        var line = l.trim();
        if (line.startsWith('[') && line.contains(']: [')) {
          final parts = line.split(']: [');
          if (parts.length >= 2) {
            final key = parts[0].substring(1);
            final value = parts.sublist(1).join(']: [');
            if (value.endsWith(']')) {
              map[key] = value.substring(0, value.length - 1);
            }
          }
        } else if (line.contains('=')) {
          final parts = line.split('=');
          map[parts[0].trim()] = parts.sublist(1).join('=').trim();
        }
      }
      return map;
    } catch (e) {
      return {};
    }
  }

  static Future<void> setChargeLimit(int mA) async {
    final microAmps = mA * 1000;
    final script =
        '''
#!/system/bin/sh
for file in /sys/class/power_supply/battery/constant_charge_current_max \\
            /sys/class/power_supply/battery/current_max \\
            /sys/class/power_supply/main/constant_charge_current_max \\
            /sys/class/power_supply/usb/current_max \\
            /sys/class/power_supply/usb/hw_current_max \\
            /sys/class/power_supply/usb/pd_current_max \\
            /sys/class/power_supply/pc_port/current_max; do
  if [ -f "\$file" ]; then
    chmod 644 "\$file" 2>/dev/null
    echo $microAmps > "\$file"
  fi
done
''';
    await Process.run('su', ['-c', script]);
  }

  static Future<void> resetChargeLimit() async {
    // Çok yüksek bir limite (30 Amper) çekerek PMIC'in (veya çift hücreli batarya kontrolcüsünün) 120W+ hızlara kadar çıkabilmesini sağlarız
    final script = '''
#!/system/bin/sh
for file in /sys/class/power_supply/battery/constant_charge_current_max \\
            /sys/class/power_supply/battery/current_max \\
            /sys/class/power_supply/main/constant_charge_current_max \\
            /sys/class/power_supply/usb/current_max \\
            /sys/class/power_supply/usb/hw_current_max \\
            /sys/class/power_supply/usb/pd_current_max \\
            /sys/class/power_supply/pc_port/current_max; do
  if [ -f "\$file" ]; then
    chmod 644 "\$file" 2>/dev/null
    echo 30000000 > "\$file"
  fi
done
''';
    await Process.run('su', ['-c', script]);
  }
}

class BatteryStats {
  final Map<String, String> rawStats;
  final String model;
  final String androidVer;
  final String rom;
  final String status;
  final int percentage;
  final double voltageV;
  final double currentA;
  final int currentMA;
  final double wattageW;
  final int capacityMAh;
  final int designCapacityMAh;
  final double batteryHealth;
  final double cpuTempC;
  final double battTempC;
  final String timeRemainingStr;
  final bool isCharging;
  final bool isFull;

  BatteryStats({
    required this.rawStats,
    required this.model,
    required this.androidVer,
    required this.rom,
    required this.status,
    required this.percentage,
    required this.voltageV,
    required this.currentA,
    required this.currentMA,
    required this.wattageW,
    required this.capacityMAh,
    required this.designCapacityMAh,
    required this.batteryHealth,
    required this.cpuTempC,
    required this.battTempC,
    required this.timeRemainingStr,
    required this.isCharging,
    required this.isFull,
  });

  factory BatteryStats.fromMap(
    Map<String, String> stats, {
    double? nativeBatteryTemp,
  }) {
    final model = stats['ro.product.model'] ?? stats['model'] ?? tr('unknown');
    final androidVer =
        stats['ro.build.version.release'] ??
        stats['android_ver'] ??
        tr('unknown');

    final romProp =
        stats['ro.build.display.id'] ??
        stats['ro.modversion'] ??
        stats['rom'] ??
        '';
    final romLower = romProp.toLowerCase();

    String romName = tr('unknown');
    String romVersion = '';

    if (romLower.contains('crdroid')) {
      romName = 'crDroid';
      romVersion =
          stats['ro.crdroid.build.version'] ??
          stats['ro.crdroid.version'] ??
          '';
    } else if (romLower.contains('hyperos') ||
        (stats['ro.mi.os.version.name']?.isNotEmpty ?? false)) {
      romName = 'HyperOS';
      romVersion = stats['ro.mi.os.version.name'] ?? '';
    } else if (romLower.contains('miui') ||
        (stats['ro.miui.ui.version.name']?.isNotEmpty ?? false)) {
      romName = 'MIUI';
      romVersion = stats['ro.miui.ui.version.name'] ?? '';
      if (romVersion.contains('816')) {
        romName = 'HyperOS';
      }
    } else if (romLower.contains('lineage')) {
      romName = 'LineageOS';
      romVersion = stats['ro.lineage.build.version'] ?? '';
    } else if (romLower.contains('evolution')) {
      romName = 'Evolution X';
      romVersion = stats['ro.evolution.version'] ?? '';
    } else if (romLower.contains('pixelos')) {
      romName = 'PixelOS';
      romVersion = stats['ro.pixelos.version'] ?? '';
    } else if (romLower.contains('pixel experience') ||
        romLower.contains('pixelexperience')) {
      romName = 'Pixel Experience';
      romVersion =
          stats['ro.pixel.build.version'] ??
          stats['ro.pixelexperience.version'] ??
          '';
    } else if (romLower.contains('arrow')) {
      romName = 'ArrowOS';
      romVersion = stats['ro.arrow.version'] ?? '';
    } else if (romLower.contains('cherish')) {
      romName = 'CherishOS';
      romVersion =
          stats['ro.cherish.version'] ??
          stats['ro.cherish.build.version'] ??
          '';
    } else if (romLower.contains('corvus')) {
      romName = 'Corvus OS';
      romVersion = stats['ro.corvus.version'] ?? '';
    } else {
      final customVerKeys = stats.keys
          .where(
            (k) =>
                k.startsWith('ro.') &&
                (k.endsWith('.version') || k.endsWith('.build.version')) &&
                !k.startsWith('ro.build.') &&
                !k.startsWith('ro.system.') &&
                !k.startsWith('ro.vendor.') &&
                !k.startsWith('ro.product.') &&
                !k.startsWith('ro.boot.'),
          )
          .toList();

      if (customVerKeys.isNotEmpty) {
        final key = customVerKeys.first;
        final parts = key.split('.');
        if (parts.length > 1) {
          final extractedName = parts[1];
          romName = extractedName[0].toUpperCase() + extractedName.substring(1);
          romVersion = stats[key] ?? '';
        }
      } else {
        final parts = romProp.split(RegExp(r'[-_ ]'));
        if (parts.isNotEmpty && parts[0].isNotEmpty) {
          romName = parts[0];
          final vMatch = RegExp(r'(v?\d+\.\d+(?:\.\d+)?)').firstMatch(romProp);
          if (vMatch != null) {
            romVersion = vMatch.group(1) ?? '';
          }
        }
      }
    }

    String formatVer(String base, String? extra) {
      if (extra != null && extra.trim().isNotEmpty) {
        return '$base ${extra.trim()}';
      }
      return base;
    }

    String rom = romVersion.isNotEmpty
        ? formatVer(romName, romVersion)
        : romName;
    if ((rom == 'Bilinmiyor' || rom == tr('unknown')) && romProp.isNotEmpty) {
      rom = romProp;
    }

    final status = stats['status'] ?? 'Unknown';
    double parseVal(String? val) {
      if (val == null || val.isEmpty) return 0.0;
      return double.tryParse(val) ?? 0.0;
    }

    final percentage = parseVal(stats['capacity']).toInt();

    final rawVoltage = parseVal(stats['voltage']);
    final rawCurrent = parseVal(stats['current']);
    final rawChargeFull = parseVal(stats['charge_full']);
    final rawChargeFullDesign = parseVal(stats['charge_full_design']);

    final bool isMicroUnits = rawVoltage > 100000;

    double voltageV = 0.0;
    if (isMicroUnits) {
      voltageV = rawVoltage / 1000000.0;
    } else if (rawVoltage > 100) {
      voltageV = rawVoltage / 1000.0;
    } else {
      voltageV = rawVoltage;
    }

    double currentA = 0.0;
    if (isMicroUnits) {
      currentA = rawCurrent.abs() / 1000000.0;
    } else if (rawCurrent.abs() > 50) {
      currentA = rawCurrent.abs() / 1000.0;
    } else {
      currentA = rawCurrent.abs();
    }

    final currentMA = (currentA * 1000).toInt();
    final wattageW = voltageV * currentA;

    int capacityMAh = 0;
    if (isMicroUnits) {
      capacityMAh = (rawChargeFull / 1000).toInt();
    } else if (rawChargeFull > 100000) {
      capacityMAh = (rawChargeFull / 1000).toInt();
    } else {
      capacityMAh = rawChargeFull.toInt();
    }

    int designCapacityMAh = 0;
    if (isMicroUnits) {
      designCapacityMAh = (rawChargeFullDesign / 1000).toInt();
    } else if (rawChargeFullDesign > 100000) {
      designCapacityMAh = (rawChargeFullDesign / 1000).toInt();
    } else {
      designCapacityMAh = rawChargeFullDesign.toInt();
    }

    double batteryHealth = 0.0;
    if (designCapacityMAh > 0 && capacityMAh > 0) {
      batteryHealth = (capacityMAh / designCapacityMAh).clamp(0.0, 1.0);
    }

    double normalizeT(double raw) {
      final absVal = raw.abs();
      if (absVal > 10000) {
        return raw / 1000.0;
      } else if (absVal > 1000) {
        return raw / 100.0;
      } else if (absVal > 100) {
        return raw / 10.0;
      }
      return raw;
    }

    double battTempC = nativeBatteryTemp ?? 0.0;
    final tzKeys = stats.keys.where((k) => k.startsWith('tz_')).toList();

    if (battTempC == 0.0) {
      final battTzKey = tzKeys.firstWhere((k) {
        final lower = k.toLowerCase();
        return (lower.contains('battery') ||
                lower.contains('batt') ||
                lower.contains('pmic')) &&
            !lower.contains('water') &&
            !lower.contains('charger') &&
            !lower.contains('chg');
      }, orElse: () => '');

      if (battTzKey.isNotEmpty) {
        final val = parseVal(stats[battTzKey]);
        if (val != 0.0) {
          final normalized = normalizeT(val);
          if (normalized >= 5.0 && normalized <= 65.0) {
            battTempC = normalized;
          }
        }
      }
    }

    if (battTempC == 0.0) {
      final rawBattTemp = parseVal(stats['batt_temp']);
      battTempC = normalizeT(rawBattTemp);
    }

    double cpuTempC = 0.0;

    final skinTzKey = tzKeys.firstWhere((k) {
      final lower = k.toLowerCase();
      return lower.contains('skin') ||
          lower.contains('surface') ||
          lower.contains('back-temp') ||
          lower.contains('back_temp');
    }, orElse: () => '');

    final activeCpuTemps = <double>[];
    for (var key in tzKeys) {
      final lower = key.toLowerCase();
      if ((lower.contains('cpu') ||
              lower.contains('apc') ||
              lower.contains('tsens') ||
              lower.contains('xo-therm') ||
              lower.contains('xo_therm')) &&
          !lower.contains('step') &&
          !lower.contains('floor') &&
          !lower.contains('cool') &&
          !lower.contains('isolated') &&
          !lower.contains('low') &&
          !lower.contains('limit') &&
          !lower.contains('state')) {
        final val = parseVal(stats[key]);
        if (val != 0.0) {
          final normalized = normalizeT(val);
          if (normalized >= 15.0 && normalized <= 95.0) {
            activeCpuTemps.add(normalized);
          }
        }
      }
    }

    double? skinTemp;
    if (skinTzKey.isNotEmpty) {
      final val = parseVal(stats[skinTzKey]);
      if (val != 0.0) {
        skinTemp = normalizeT(val);
      }
    }

    final xoKey = tzKeys.firstWhere(
      (k) =>
          k.toLowerCase().contains('xo-therm') ||
          k.toLowerCase().contains('xo_therm'),
      orElse: () => '',
    );
    double? xoTemp;
    if (xoKey.isNotEmpty) {
      final val = parseVal(stats[xoKey]);
      if (val != 0.0) {
        xoTemp = normalizeT(val);
      }
    }

    final cleanCpuTemps = activeCpuTemps.where((t) {
      final isTripPoint =
          (t - 60.2).abs() < 0.05 ||
          (t - 60.0).abs() < 0.05 ||
          (t - 40.0).abs() < 0.05 ||
          (t - 42.4).abs() < 0.05;
      return !isTripPoint;
    }).toList();

    if (cleanCpuTemps.isNotEmpty) {
      cpuTempC = cleanCpuTemps.reduce((a, b) => a + b) / cleanCpuTemps.length;
    } else if (xoTemp != null && xoTemp > 15.0 && xoTemp < 60.0) {
      cpuTempC = xoTemp;
    } else if (skinTemp != null && skinTemp > 15.0 && skinTemp < 60.0) {
      cpuTempC = skinTemp;
    } else if (activeCpuTemps.isNotEmpty) {
      cpuTempC = activeCpuTemps.reduce((a, b) => a + b) / activeCpuTemps.length;
    } else {
      final rawCpuTemp = parseVal(stats['cpu_temp']);
      cpuTempC = normalizeT(rawCpuTemp);
    }

    final statusLower = status.trim().toLowerCase();
    final isCharging =
        statusLower == 'charging' ||
        (statusLower.contains('charging') &&
            !statusLower.contains('dis') &&
            !statusLower.contains('not'));
    final isFull = percentage >= 100 || statusLower == 'full';

    String timeRemainingStr = tr('cannot_calculate');
    if (isFull) {
      timeRemainingStr = tr('full');
    } else if (isCharging && currentA > 0.05 && capacityMAh > 0) {
      final remainingMAh = capacityMAh * (100 - percentage) / 100.0;
      final timeHours = remainingMAh / currentMA;
      final timeMins = (timeHours * 60).round();
      if (timeMins > 0) {
        timeRemainingStr = tr('full_in_mins', [timeMins.toString()]);
      } else {
        timeRemainingStr = tr('almost_full');
      }
    } else if (!isCharging) {
      timeRemainingStr = tr('not_charging');
    }

    return BatteryStats(
      rawStats: stats,
      model: model,
      androidVer: androidVer,
      rom: rom,
      status: status,
      percentage: percentage,
      voltageV: voltageV,
      currentA: currentA,
      currentMA: currentMA,
      wattageW: wattageW,
      capacityMAh: capacityMAh,
      designCapacityMAh: designCapacityMAh,
      batteryHealth: batteryHealth,
      cpuTempC: cpuTempC,
      battTempC: battTempC,
      timeRemainingStr: timeRemainingStr,
      isCharging: isCharging,
      isFull: isFull,
    );
  }
}


/// Shown only on first launch (before language_selected pref is set).
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selected = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.language_rounded, size: 80, color: Color(0xFF38BDF8)),
                const SizedBox(height: 32),
                const Text(
                  'Watt Meter',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select Language / Dil Seçin',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 48),
                _buildLangOption(
                  label: 'English',
                  subtitle: 'English',
                  flag: '🇬🇧',
                  value: 'en',
                ),
                const SizedBox(height: 16),
                _buildLangOption(
                  label: 'Türkçe',
                  subtitle: 'Turkish',
                  flag: '🇹🇷',
                  value: 'tr',
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () async {
                    await SettingsManager.setLanguage(_selected);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _selected == 'en' ? 'Continue' : 'Devam Et',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangOption({
    required String label,
    required String subtitle,
    required String flag,
    required String value,
  }) {
    final isSelected = _selected == value;
    return GestureDetector(
      onTap: () => setState(() => _selected = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF38BDF8).withOpacity(0.15)
              : const Color(0xFF1E293B).withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF38BDF8) : Colors.white10,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF38BDF8) : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF38BDF8), size: 24),
          ],
        ),
      ),
    );
  }
}

void showSettingsBottomSheet(BuildContext context) {

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E293B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return const SettingsBottomSheetContent();
    },
  );
}

class SettingsBottomSheetContent extends StatelessWidget {
  const SettingsBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr('settings'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Language selection
            Text(
              tr('language'),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: LanguageManager.localeNotifier,
              builder: (context, locale, child) {
                return Row(
                  children: [
                    _buildOptionButton(
                      context: context,
                      label: tr('turkish'),
                      isSelected: locale == 'tr',
                      onTap: () => SettingsManager.setLanguage('tr'),
                    ),
                    const SizedBox(width: 12),
                    _buildOptionButton(
                      context: context,
                      label: tr('english'),
                      isSelected: locale == 'en',
                      onTap: () => SettingsManager.setLanguage('en'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Working Mode selection
            Text(
              tr('working_mode'),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String?>(
              valueListenable: SettingsManager.workingModeNotifier,
              builder: (context, mode, child) {
                return Row(
                  children: [
                    _buildOptionButton(
                      context: context,
                      label: tr('rooted'),
                      isSelected: mode == 'rooted',
                      onTap: () {
                        SettingsManager.setWorkingMode('rooted');
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildOptionButton(
                      context: context,
                      label: tr('rootless'),
                      isSelected: mode == 'rootless',
                      onTap: () {
                        SettingsManager.setWorkingMode('rootless');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF38BDF8).withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF38BDF8)
                  : Colors.white10,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF38BDF8) : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.settings_rounded, color: Colors.white70, size: 28),
                  onPressed: () => showSettingsBottomSheet(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      size: 100,
                      color: Color(0xFF38BDF8),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      tr('app_title'),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr('how_to_continue'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        SettingsManager.setWorkingMode('rooted');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF43F5E),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        tr('rooted_mode'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        SettingsManager.setWorkingMode('rootless');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        tr('rootless_mode'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class RootCheckScreen extends StatefulWidget {
  const RootCheckScreen({super.key});

  @override
  State<RootCheckScreen> createState() => _RootCheckScreenState();
}

class _RootCheckScreenState extends State<RootCheckScreen> {
  bool _isChecking = true;
  bool _hasRoot = false;

  @override
  void initState() {
    super.initState();
    _checkRootAccess();
  }

  Future<void> _checkRootAccess() async {
    setState(() => _isChecking = true);
    final isRooted = await RootService.hasRoot();
    setState(() {
      _hasRoot = isRooted;
      _isChecking = false;
    });

    if (isRooted && mounted) {
      // Signal AppHomeRouter to render DashboardScreen(isRooted: true)
      // instead of pushing a new route — keeps all routing centralised.
      SettingsManager.confirmRoot();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.settings_rounded, color: Colors.white70, size: 28),
                onPressed: () => showSettingsBottomSheet(context),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 100,
                      color: Color(0xFF38BDF8),
                    ),
                    const SizedBox(height: 32),
                    if (_isChecking)
                      Column(
                        children: [
                          const CircularProgressIndicator(color: Color(0xFF38BDF8)),
                          const SizedBox(height: 24),
                          Text(
                            tr('checking_root'),
                            style: const TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                        ],
                      )
                    else if (!_hasRoot)
                      Column(
                        children: [
                          Text(
                            tr('root_required'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            tr('root_required_desc'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white54,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 48),
                          ElevatedButton(
                            onPressed: _checkRootAccess,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38BDF8),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 8,
                              shadowColor: const Color(0xFF38BDF8).withOpacity(0.5),
                            ),
                            child: Text(
                              tr('retry_root'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final bool isRooted;

  const DashboardScreen({super.key, this.isRooted = true});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  BatteryStats? _batteryStats;
  static const _batteryChannel = MethodChannel(
    'com.example.watt_mater/battery',
  );

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final TextEditingController _maController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _updateStats();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _updateStats());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _maController.dispose();
    super.dispose();
  }

  Future<void> _updateStats() async {
    Map<String, String> stats = {};
    if (widget.isRooted) {
      stats = await RootService.fetchStats();
    } else {
      try {
        final Map<Object?, Object?>? result = await _batteryChannel
            .invokeMethod('getBatteryStats');
        if (result != null) {
          stats = result.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          );
        }
      } catch (e) {
        // Method channel fail
      }
    }

    double? nativeBatteryTemp;
    try {
      final double? temp = await _batteryChannel.invokeMethod<double>(
        'getBatteryTemperature',
      );
      nativeBatteryTemp = temp;
    } catch (_) {
      // MethodChannel not available
    }

    if (mounted) {
      setState(() {
        _batteryStats = BatteryStats.fromMap(
          stats,
          nativeBatteryTemp: nativeBatteryTemp,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_batteryStats == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
        ),
      );
    }

    final stats = _batteryStats!;
    final model = (stats.model == 'Bilinmiyor' || stats.model == 'Unknown') ? tr('unknown') : stats.model;
    final androidVer = (stats.androidVer == 'Bilinmiyor' || stats.androidVer == 'Unknown') ? tr('unknown') : stats.androidVer;
    final rom = (stats.rom == 'Bilinmiyor' || stats.rom == 'Unknown') ? tr('unknown') : stats.rom;
    final percentage = stats.percentage;
    final voltageV = stats.voltageV;
    final currentMA = stats.currentMA;
    final wattageW = stats.wattageW;
    final capacityMAh = stats.capacityMAh;
    final designCapacityMAh = stats.designCapacityMAh;
    final batteryHealth = stats.batteryHealth;
    final battTempC = stats.battTempC;
    final isCharging = stats.isCharging;

    // Dynamically calculate timeRemainingStr to update immediately on language switch
    String timeRemainingStr = tr('cannot_calculate');
    if (stats.isFull) {
      timeRemainingStr = tr('full');
    } else if (isCharging && currentMA > 50 && capacityMAh > 0) {
      final remainingMAh = capacityMAh * (100 - percentage) / 100.0;
      final timeHours = remainingMAh / currentMA;
      final timeMins = (timeHours * 60).round();
      if (timeMins > 0) {
        timeRemainingStr = tr('full_in_mins', [timeMins.toString()]);
      } else {
        timeRemainingStr = tr('almost_full');
      }
    } else if (!isCharging) {
      timeRemainingStr = tr('not_charging');
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr('app_title'),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.isRooted ? tr('root_active') : tr('rootless_active'),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: widget.isRooted
                                    ? Colors.greenAccent
                                    : Colors.orangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.settings_rounded, color: Colors.white70, size: 28),
                            onPressed: () => showSettingsBottomSheet(context),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(
                              0xFF38BDF8,
                            ).withOpacity(0.2),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: Color(0xFF38BDF8),
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Main Wattage Circle
                  Center(
                    child: ScaleTransition(
                      scale: isCharging
                          ? _pulseAnimation
                          : const AlwaysStoppedAnimation(1.0),
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: isCharging
                                ? const [
                                    Color(0xFF38BDF8),
                                    Color(0xFF818CF8),
                                    Color(0xFF38BDF8),
                                  ]
                                : const [
                                    Color(0xFF475569),
                                    Color(0xFF334155),
                                    Color(0xFF475569),
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isCharging
                                  ? const Color(0xFF38BDF8).withOpacity(0.4)
                                  : Colors.transparent,
                              blurRadius: 32,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF1E293B),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isCharging
                                      ? wattageW.toStringAsFixed(1)
                                      : '-${wattageW.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w900,
                                    color: isCharging
                                        ? Colors.white
                                        : Colors.white54,
                                    height: 1.0,
                                  ),
                                ),
                                Text(
                                  isCharging ? tr('charge_watt') : tr('discharge_watt'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    color: isCharging
                                        ? const Color(0xFF38BDF8)
                                        : Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Info Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    children: [
                      _buildInfoCard(
                        icon: Icons.electric_meter_rounded,
                        title: isCharging ? tr('current_charge') : tr('current_discharge'),
                        value: isCharging
                            ? '${currentMA} mA'
                            : '-${currentMA} mA',
                        color: const Color(0xFFF43F5E),
                      ),
                      _buildInfoCard(
                        icon: Icons.electrical_services_rounded,
                        title: tr('voltage'),
                        value: '${voltageV.toStringAsFixed(2)} V',
                        color: const Color(0xFF10B981),
                      ),
                      _buildInfoCard(
                        icon: Icons.battery_charging_full_rounded,
                        title: tr('capacity'),
                        value: capacityMAh > 0
                            ? '${capacityMAh} mAh'
                            : tr('unknown'),
                        color: const Color(0xFFF59E0B),
                      ),
                      _buildInfoCard(
                        icon: Icons.percent_rounded,
                        title: tr('charge_percentage'),
                        value: '%${percentage}',
                        color: const Color(0xFF8B5CF6),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Battery Temp Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF97316).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.device_thermostat_rounded,
                            color: Color(0xFFF97316),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('battery_temp'),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                battTempC != 0.0
                                    ? '${battTempC.toStringAsFixed(1)} °C'
                                    : tr('unknown'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Estimation Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.timer_outlined,
                            color: Color(0xFF38BDF8),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('charge_time_est'),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timeRemainingStr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Battery Health Card
                  if (designCapacityMAh > 0 && capacityMAh > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.health_and_safety_rounded,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr('battery_health'),
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '%${(batteryHealth * 100).toStringAsFixed(1)} (${capacityMAh} / ${designCapacityMAh} mAh)',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: batteryHealth,
                              minHeight: 8,
                              backgroundColor: const Color(0xFF0F172A),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                batteryHealth > 0.8
                                    ? const Color(0xFF10B981)
                                    : batteryHealth > 0.6
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFFF43F5E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (designCapacityMAh > 0 && capacityMAh > 0)
                    const SizedBox(height: 16),

                  // Device Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('device_info'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDeviceRow(tr('model'), model),
                        const SizedBox(height: 12),
                        _buildDeviceRow(tr('android_version'), androidVer),
                        const SizedBox(height: 12),
                        _buildDeviceRow(tr('rom_version'), rom),
                      ],
                    ),
                  ),

                  if (widget.isRooted) ...[
                    const SizedBox(height: 16),
                    _buildChargeLimiterCard(context),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeLimiterCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.speed_rounded, color: Color(0xFFF43F5E)),
              const SizedBox(width: 8),
              Text(
                tr('charge_limiter'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _maController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: tr('example_ma'),
                    hintStyle: const TextStyle(color: Colors.white38),
                    labelText: tr('manual_ma'),
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.black26,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  final val = int.tryParse(_maController.text);
                  if (val != null && val > 0) {
                    RootService.setChargeLimit(val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr('limit_set_msg', [val.toString()])),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF43F5E),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  tr('apply'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            tr('quick_limits'),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildWattButton(5),
              _buildWattButton(10),
              _buildWattButton(15),
              _buildWattButton(20),
              _buildWattButton(30),
              _buildWattButton(33),
              _buildWattButton(45),
              _buildWattButton(67),
              _buildWattButton(100),
              _buildWattButton(120),
              OutlinedButton(
                onPressed: () {
                  RootService.resetChargeLimit();
                  _maController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tr('limit_reset_msg'))),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  tr('reset'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWattButton(int watt) {
    return ActionChip(
      label: Text(
        '${watt}W',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF38BDF8).withOpacity(0.2),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: () {
        // Pil voltajı genelde ortalama 4.0V civarındadır (Watt = Amper * Voltaj)
        final mA = ((watt / 4.0) * 1000).round();
        _maController.text = mA.toString();
        RootService.setChargeLimit(mA);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('limit_watt_set_msg', [watt.toString(), mA.toString()]))),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
