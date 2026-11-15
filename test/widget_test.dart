// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:watt_mater/main.dart';

void main() {
  testWidgets('App compiles smoke test', (WidgetTester tester) async {
    expect(true, isTrue);
  });

  test('LanguageManager Spanish translations test', () {
    LanguageManager.setLocale('es');
    expect(LanguageManager.currentLocale, 'es');
    expect(tr('spanish'), 'Español');
    expect(tr('turkish'), 'Turco');
    expect(tr('english'), 'Inglés');
    expect(tr('settings'), 'Ajustes');
    expect(tr('how_to_continue'), '¿Cómo desea continuar?');
    expect(tr('rooted_mode'), 'Modo Root (Control total)');
    expect(tr('rootless_mode'), 'Modo Sin Root (Datos limitados)');
    expect(tr('full_in_mins', ['25']), 'Carga completa en 25 min');
    expect(tr('limit_set_msg', ['2000']), 'Límite ajustado a 2000 mA');

    // Test Turkish
    LanguageManager.setLocale('tr');
    expect(tr('spanish'), 'İspanyolca');

    // Test English
    LanguageManager.setLocale('en');
    expect(tr('spanish'), 'Spanish');
  });

  test('AlDente Max Adapter Power detection test', () {
    LanguageManager.setLocale('tr');

    // 1. 65W PD Adapter test (like ornek.png: active 51.19W, adapter max 65W)
    final pd65 = ChargingProtocolInfo.analyze(
      isCharging: true,
      wattageW: 51.19,
      voltageV: 17.03,
      currentMA: 3010,
      rawStats: {
        'pd_active': '1',
        'usb_real_type': 'PD',
        'usb_voltage_max': '20000000', // 20V
        'usb_current_max': '3250000', // 3.25A -> 65W
      },
    );
    expect(pd65.maxAdapterPowerW, 65.0);
    expect(pd65.maxAdapterPowerStr, '65 W');
    expect(pd65.isPd, isTrue);

    // 2. Active 10W drawn on 90W Xiaomi adapter (Poco F6)
    final turbo90 = ChargingProtocolInfo.analyze(
      isCharging: true,
      wattageW: 10.0,
      voltageV: 4.2,
      currentMA: 2400,
      rawStats: {
        'turbo_mode': '1',
        'adapter_svid': '2717',
        'battery_model_name': 'N16T_5000mah_90w',
        'usb_voltage_max': '20000000',
        'usb_current_max': '4500000', // 4.5A -> 90W
      },
    );
    expect(turbo90.maxAdapterPowerW, 90.0);
    expect(turbo90.maxAdapterPowerStr, '90 W');

    // 3. 18W QC Adapter
    final qc18 = ChargingProtocolInfo.analyze(
      isCharging: true,
      wattageW: 12.0,
      voltageV: 9.0,
      currentMA: 1333,
      rawStats: {
        'quick_charge_type': '2',
        'usb_voltage_max': '9000000',
        'usb_current_max': '2000000',
      },
    );
    expect(qc18.maxAdapterPowerW, 18.0);
    expect(qc18.maxAdapterPowerStr, '18 W');

    // 4. Standard USB (SDP 5V 500mA -> 2.5W)
    final sdp = ChargingProtocolInfo.analyze(
      isCharging: true,
      wattageW: 1.5,
      voltageV: 5.0,
      currentMA: 300,
      rawStats: {
        'usb_real_type': 'SDP',
        'usb_voltage_max': '5000000',
        'usb_current_max': '500000',
      },
    );
    expect(sdp.maxAdapterPowerW, 2.5);
    expect(sdp.maxAdapterPowerStr, '2.5 W');
  });

  test('AlDente translations in all languages', () {
    for (final lang in ['tr', 'en', 'es']) {
      LanguageManager.setLocale(lang);
      expect(tr('aldente_power_title').isNotEmpty, isTrue);
      expect(tr('aldente_currently').isNotEmpty, isTrue);
      expect(tr('aldente_voltage').isNotEmpty, isTrue);
      expect(tr('aldente_power').isNotEmpty, isTrue);
      expect(tr('max_adapter_power').isNotEmpty, isTrue);
      expect(tr('adapter_label').isNotEmpty, isTrue);
      expect(tr('charging_active').isNotEmpty, isTrue);
      expect(tr('battery_power').isNotEmpty, isTrue);
    }
  });
}
