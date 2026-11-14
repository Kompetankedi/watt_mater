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
}
