import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const WattMeterApp());
}

class WattMeterApp extends StatelessWidget {
  const WattMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watt Mater',
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
      home: const RootCheckScreen(),
      debugShowCheckedModeBanner: false,
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
    const script = '''
#!/system/bin/sh
getprop
echo "---BATTERY---"
echo "capacity=\$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo '0')"
echo "voltage=\$(cat /sys/class/power_supply/battery/voltage_now 2>/dev/null || echo '0')"
echo "current=\$(cat /sys/class/power_supply/battery/current_now 2>/dev/null || echo '0')"
echo "charge_full=\$(cat /sys/class/power_supply/bms/charge_full 2>/dev/null || cat /sys/class/power_supply/battery/charge_full 2>/dev/null || echo '0')"
echo "charge_full_design=\$(cat /sys/class/power_supply/bms/charge_full_design 2>/dev/null || cat /sys/class/power_supply/battery/charge_full_design 2>/dev/null || echo '0')"
echo "status=\$(cat /sys/class/power_supply/battery/status 2>/dev/null || echo 'Unknown')"
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
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const DashboardScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                const Column(
                  children: [
                    CircularProgressIndicator(color: Color(0xFF38BDF8)),
                    SizedBox(height: 24),
                    Text(
                      'Root İzni Kontrol Ediliyor...',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    )
                  ],
                )
              else if (!_hasRoot)
                Column(
                  children: [
                    const Text(
                      'Root İzni Gerekli',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Watt Mater uygulamasının pil donanım bilgilerine erişebilmesi için root yetkisine ihtiyacı vardır. Lütfen Magisk veya KernelSU üzerinden izin verin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white54, height: 1.5),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: _checkRootAccess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF38BDF8).withOpacity(0.5),
                      ),
                      child: const Text(
                        'Root İzni İste / Tekrar Dene',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  Timer? _timer;
  Map<String, String> _stats = {};
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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
    super.dispose();
  }

  Future<void> _updateStats() async {
    final stats = await RootService.fetchStats();
    if (mounted) {
      setState(() {
        _stats = stats;
      });
    }
  }

  double _parseValue(String? val) {
    if (val == null || val.isEmpty) return 0.0;
    return double.tryParse(val) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final model = _stats['ro.product.model'] ?? _stats['model'] ?? 'Bilinmiyor';
    final androidVer = _stats['ro.build.version.release'] ?? _stats['android_ver'] ?? 'Bilinmiyor';
    
    final romProp = _stats['ro.build.display.id'] ?? _stats['ro.modversion'] ?? _stats['rom'] ?? '';
    final romLower = romProp.toLowerCase();

    String romName = 'Bilinmiyor';
    String romVersion = '';

    if (romLower.contains('crdroid')) {
      romName = 'crDroid';
      romVersion = _stats['ro.crdroid.build.version'] ?? _stats['ro.crdroid.version'] ?? '';
    } else if (romLower.contains('hyperos') || (_stats['ro.mi.os.version.name']?.isNotEmpty ?? false)) {
      romName = 'HyperOS';
      romVersion = _stats['ro.mi.os.version.name'] ?? '';
    } else if (romLower.contains('miui') || (_stats['ro.miui.ui.version.name']?.isNotEmpty ?? false)) {
      romName = 'MIUI';
      romVersion = _stats['ro.miui.ui.version.name'] ?? '';
      if (romVersion.contains('816')) {
         romName = 'HyperOS';
      }
    } else if (romLower.contains('lineage')) {
      romName = 'LineageOS';
      romVersion = _stats['ro.lineage.build.version'] ?? '';
    } else if (romLower.contains('evolution')) {
      romName = 'Evolution X';
      romVersion = _stats['ro.evolution.version'] ?? '';
    } else if (romLower.contains('pixelos')) {
      romName = 'PixelOS';
      romVersion = _stats['ro.pixelos.version'] ?? '';
    } else if (romLower.contains('pixel experience') || romLower.contains('pixelexperience')) {
      romName = 'Pixel Experience';
      romVersion = _stats['ro.pixel.build.version'] ?? _stats['ro.pixelexperience.version'] ?? '';
    } else if (romLower.contains('arrow')) {
      romName = 'ArrowOS';
      romVersion = _stats['ro.arrow.version'] ?? '';
    } else if (romLower.contains('cherish')) {
      romName = 'CherishOS';
      romVersion = _stats['ro.cherish.version'] ?? _stats['ro.cherish.build.version'] ?? '';
    } else if (romLower.contains('corvus')) {
      romName = 'Corvus OS';
      romVersion = _stats['ro.corvus.version'] ?? '';
    } else {
      final customVerKeys = _stats.keys.where((k) => 
        k.startsWith('ro.') && 
        (k.endsWith('.version') || k.endsWith('.build.version')) && 
        !k.startsWith('ro.build.') && !k.startsWith('ro.system.') && 
        !k.startsWith('ro.vendor.') && !k.startsWith('ro.product.') && 
        !k.startsWith('ro.boot.')).toList();
      
      if (customVerKeys.isNotEmpty) {
        final key = customVerKeys.first;
        final parts = key.split('.');
        if (parts.length > 1) {
          final extractedName = parts[1];
          romName = extractedName[0].toUpperCase() + extractedName.substring(1);
          romVersion = _stats[key] ?? '';
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

    String rom = romVersion.isNotEmpty ? formatVer(romName, romVersion) : romName;
    if (rom == 'Bilinmiyor' && romProp.isNotEmpty) {
       rom = romProp;
    }
    final status = _stats['status'] ?? 'Unknown';
    final percentage = _parseValue(_stats['capacity']).toInt();
    
    final rawVoltage = _parseValue(_stats['voltage']);
    final rawCurrent = _parseValue(_stats['current']);
    final rawChargeFull = _parseValue(_stats['charge_full']);
    final rawChargeFullDesign = _parseValue(_stats['charge_full_design']);

    // Voltage in Volts
    double voltageV = 0.0;
    if (rawVoltage > 100000) {
      voltageV = rawVoltage / 1000000.0;
    } else if (rawVoltage > 100) {
      voltageV = rawVoltage / 1000.0;
    } else {
      voltageV = rawVoltage;
    }

    // Current in Amperes
    double currentA = 0.0;
    if (rawCurrent.abs() > 20000) {
      currentA = rawCurrent.abs() / 1000000.0;
    } else if (rawCurrent.abs() > 50) {
      currentA = rawCurrent.abs() / 1000.0;
    } else {
      currentA = rawCurrent.abs();
    }
    
    // Sometimes when discharging, battery current can be negative. Let's just use abs for magnitude.
    final currentMA = (currentA * 1000).toInt();
    final wattageW = voltageV * currentA;

    // Battery Capacity
    int capacityMAh = 0;
    if (rawChargeFull > 100000) {
      capacityMAh = (rawChargeFull / 1000).toInt();
    } else {
      capacityMAh = rawChargeFull.toInt();
    }

    int designCapacityMAh = 0;
    if (rawChargeFullDesign > 100000) {
      designCapacityMAh = (rawChargeFullDesign / 1000).toInt();
    } else {
      designCapacityMAh = rawChargeFullDesign.toInt();
    }
    
    // If the OS returns 0 for design capacity but we know it should have one, we could leave it 0
    // and it just won't show the health bar.
    double batteryHealth = 0.0;
    if (designCapacityMAh > 0 && capacityMAh > 0) {
      batteryHealth = (capacityMAh / designCapacityMAh).clamp(0.0, 1.0);
    }

    final statusLower = status.trim().toLowerCase();
    final isCharging = statusLower == 'charging' || (statusLower.contains('charging') && !statusLower.contains('dis') && !statusLower.contains('not'));
    final isFull = percentage >= 100 || statusLower == 'full';

    // Time untill full charge
    String timeRemainingStr = "Hesaplanamıyor";
    if (isFull) {
      timeRemainingStr = "Tam dolu";
    } else if (isCharging && currentA > 0.05 && capacityMAh > 0) {
      final remainingMAh = capacityMAh * (100 - percentage) / 100.0;
      final timeHours = remainingMAh / currentMA;
      final timeMins = (timeHours * 60).round();
      if (timeMins > 0) {
        timeRemainingStr = "${timeMins} dk sonra tam dolu";
      } else {
        timeRemainingStr = "Neredeyse doldu";
      }
    } else if (!isCharging) {
      timeRemainingStr = "Şarjda değil";
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
                          const Text(
                            'Watt Mater',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'ROOT AKTİF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF38BDF8).withOpacity(0.2),
                        child: const Icon(Icons.bolt_rounded, color: Color(0xFF38BDF8), size: 32),
                      )
                    ],
                  ),
                  
                  const SizedBox(height: 48),

                  // Main Wattage Circle
                  Center(
                    child: ScaleTransition(
                      scale: isCharging ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: isCharging 
                              ? const [Color(0xFF38BDF8), Color(0xFF818CF8), Color(0xFF38BDF8)]
                              : const [Color(0xFF475569), Color(0xFF334155), Color(0xFF475569)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isCharging ? const Color(0xFF38BDF8).withOpacity(0.4) : Colors.transparent,
                              blurRadius: 32,
                              spreadRadius: 8,
                            )
                          ]
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
                                  isCharging ? wattageW.toStringAsFixed(1) : '-${wattageW.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w900,
                                    color: isCharging ? Colors.white : Colors.white54,
                                    height: 1.0,
                                  ),
                                ),
                                Text(
                                  isCharging ? 'ŞARJ WATT' : 'DEŞARJ WATT',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    color: isCharging ? const Color(0xFF38BDF8) : Colors.white54,
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
                        title: isCharging ? 'Akım (Şarj)' : 'Akım (Deşarj)',
                        value: isCharging ? '${currentMA} mA' : '-${currentMA} mA',
                        color: const Color(0xFFF43F5E),
                      ),
                      _buildInfoCard(
                        icon: Icons.electrical_services_rounded,
                        title: 'Voltaj',
                        value: '${voltageV.toStringAsFixed(2)} V',
                        color: const Color(0xFF10B981),
                      ),
                      _buildInfoCard(
                        icon: Icons.battery_charging_full_rounded,
                        title: 'Kapasite',
                        value: capacityMAh > 0 ? '${capacityMAh} mAh' : 'Bilinmiyor',
                        color: const Color(0xFFF59E0B),
                      ),
                      _buildInfoCard(
                        icon: Icons.percent_rounded,
                        title: 'Doluluk',
                        value: '%${percentage}',
                        color: const Color(0xFF8B5CF6),
                      ),
                    ],
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
                           child: const Icon(Icons.timer_outlined, color: Color(0xFF38BDF8)),
                         ),
                         const SizedBox(width: 16),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text(
                                 'Şarj Süresi Tahmini',
                                 style: TextStyle(color: Colors.white54, fontSize: 13),
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
                         )
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
                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.health_and_safety_rounded, color: Color(0xFF10B981)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Pil Sağlığı / Ömrü',
                                      style: TextStyle(color: Colors.white54, fontSize: 13),
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
                              )
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
                                batteryHealth > 0.8 ? const Color(0xFF10B981) : 
                                batteryHealth > 0.6 ? const Color(0xFFF59E0B) : const Color(0xFFF43F5E),
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
                        const Text(
                          'Cihaz Bilgileri',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDeviceRow('Model', model),
                        const SizedBox(height: 12),
                        _buildDeviceRow('Android Sürümü', androidVer),
                        const SizedBox(height: 12),
                        _buildDeviceRow('ROM Sürümü', rom),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
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
        Text(title, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
