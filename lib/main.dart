import 'dart:async';
import 'dart:io';
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
    final translations =
        _localizedValues[localeNotifier.value] ?? _localizedValues['en'] ?? _localizedValues['tr']!;
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
      'root_required_desc':
          'Watt Mater uygulamasının pil donanım bilgilerine erişebilmesi için root yetkisine ihtiyacı vardır. Lütfen Magisk veya KernelSU üzerinden izin verin.',
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
      'cycles_count': '{} döngü',
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
      'spanish': 'İspanyolca',
      'rooted': 'Rootlu',
      'rootless': 'Rootsuz',
      'close': 'Kapat',
      'active': 'Aktif',
      'inactive': 'Aktif Değil',
      'select_language': 'Dil Seçin',
      'select_language_desc': 'Devam etmek için bir dil seçin',
      'continue_btn': 'Devam Et',
      'beta': 'BETA',
      'charging_protocol': 'Şarj Protokolü',
      'beta_warning_title': 'BETA ÖZELLİK UYARISI',
      'protocol_beta_warning':
          'Şarj protokol tespiti henüz Beta aşamasındadır. Farklı işlemci (Qualcomm, MediaTek, Exynos, Tensor), üretici ROM\'ları veya kernel sürümlerinde protokol sonuçları farklılık gösterebilir ya da hatalı algılanabilir.',
      'protocol_beta_warning_short':
          'Beta: Protokol tespiti cihaz ve kernel yapısına göre farklılık veya hata gösterebilir.',
      'pd_vs_qc_title': 'PD mi QC mi?',
      'pmic_verified': 'PMIC Doğrulandı',
      'estimated_mode': 'Rootsuz Tahmin',
      'sub_mi_turbo_pps': 'USB-PD PPS + Mi Turbo Charge',
      'sub_mi_turbo': 'USB-PD Protokolü Tabanlı Turbo Şarj',
      'sub_pd_pps': 'USB Power Delivery 3.0 PPS (20mV Dinamik Voltaj)',
      'sub_pd': 'USB Type-C Power Delivery (CC Dijital Anlaşma)',
      'sub_qc4': 'Qualcomm QC 4/4+ (USB-PD PPS Çift Standart)',
      'sub_qc3p': 'Qualcomm Quick Charge 3+ (HVDCP 3+)',
      'sub_qc3': 'Qualcomm Quick Charge 3.0 (200mV Kademeli Voltaj)',
      'sub_qc2': 'Qualcomm Quick Charge 2.0 (9V/12V Sabit Yüksek Voltaj)',
      'sub_qc': 'Qualcomm HVDCP Hızlı Şarj',
      'sub_supervooc': 'SuperVOOC / Warp / Dart Yüksek Akım',
      'sub_samsung_afc': 'Samsung Adaptive Fast Charging (AFC 15W)',
      'sub_dcp': 'Dedicated Charging Port (Standart 5V Adaptör)',
      'sub_wireless': 'Kablosuz Endüksiyon Şarjı (Qi Standardı)',
      'sub_slow_usb': 'Standart USB / Bilgisayar Veri Portu (500mA - 900mA)',
      'sub_est_ultra': '~{}W Güç (Muhtemelen PD PPS / Turbo)',
      'title_est_fast': 'Hızlı Şarj (PD / QC)',
      'sub_est_fast': '~{}W Hızlı Şarj (USB-PD veya QC Uyumlu)',
      'sub_est_dcp': '~{}W Standart Hızlı Şarj',
      'sub_est_slow': '~{}W Düşük Güç (Standart USB)',
      'ladder_pd_active': '⚡ USB-PD AKTİF',
      'ladder_qc_active': '⚡ QUALCOMM QC AKTİF',
      'status_active_fmt': 'Aktif ({})',
      'status_disabled': 'Devre Dışı (0)',
      'status_hardware': 'Aktif (Donanım)',
      'line_volt_fmt': '{} V (Hat)',
      'volt_standard': '~5.0 V (Standart)',
      'volt_qc_hvdcp': '~9.0 V (QC HVDCP)',
      'volt_pd_high': '~9.0V - 15.0V (PD)',
      'volt_pd_profile': '~9.0 V (PD Profili)',
      'pmic_read': 'OKUNDU',
      'pmic_rootless': 'ROOTSUZ',
      'protocol_pd': 'USB Power Delivery (PD)',
      'protocol_pd_pps': 'USB-PD PPS (Dinamik Voltaj)',
      'protocol_qc': 'Qualcomm Quick Charge (QC)',
      'protocol_qc2': 'Qualcomm Quick Charge 2.0 (QC 2.0)',
      'protocol_qc3': 'Qualcomm Quick Charge 3.0 (QC 3.0)',
      'protocol_qc3p': 'Qualcomm Quick Charge 3+ (QC 3+)',
      'protocol_qc4': 'Qualcomm Quick Charge 4/4+ (PD PPS)',
      'protocol_mi_turbo': 'Mi Turbo Charge / HyperCharge',
      'protocol_supervooc': 'SuperVOOC / Warp / Dart',
      'protocol_samsung_afc': 'Samsung Hızlı Şarj (AFC)',
      'protocol_dcp': 'Standart Hızlı Adaptör (DCP 5V)',
      'protocol_sdp_cdp': 'Standart USB Portu (PC / Yavaş)',
      'protocol_wireless': 'Kablosuz Şarj (Wireless Qi)',
      'protocol_discharging': 'Deşarj Oluyor (Pilden Tüketim)',
      'protocol_unknown': 'Protokol Tespiti Yapılıyor...',
      'active_connection': 'AKTİF BAĞLANTI',
      'inactive_connection': 'BAĞLI DEĞİL',
      'pd_status': 'PD Durumu',
      'qc_status': 'QC Durumu',
      'pmic_register': 'PMIC Kaydı',
      'line_voltage': 'Giriş / Hat Voltajı',
      'speed_level': 'Şarj Hızı Kademesi',
      'speed_slow': 'Yavaş Şarj',
      'speed_normal': 'Normal Şarj',
      'speed_fast': 'Hızlı Şarj',
      'speed_super': 'Süper Hızlı',
      'speed_ultra': 'Ultra / Turbo',
      'step_standard_5v': 'Standart 5V',
      'step_qualcomm_qc': 'Qualcomm QC',
      'step_usb_pd': 'USB-PD',
      'step_pd_pps_turbo': 'PD-PPS / Turbo',
      'info_sheet_title': 'Şarj Protokolleri: PD vs QC',
      'info_sheet_subtitle': 'Telefonunuzun Şarj Teknolojisi Hakkında Bilgiler',
      'what_is_pd_title': 'USB Power Delivery (PD) Nedir?',
      'what_is_pd_desc':
          'USB-IF tarafından geliştirilen evrensel Type-C standardıdır. CC pinleri üzerinden dijital el sıkışma yapılır. 5V, 9V, 12V, 15V, 20V ve PPS (20mV adımlı) dinamik voltaj sunarak ısınmayı minimumda tutar. Modern tüm Android ve iPhone cihazların ana standardıdır.',
      'what_is_qc_title': 'Qualcomm Quick Charge (QC) Nedir?',
      'what_is_qc_desc':
          'Qualcomm tarafından Snapdragon cihazlar için geliştirilmiş tescilli yüksek voltaj şarj teknolojisidir. USB D+/D- veri hatları üzerinden voltajı 5V\'tan 9V veya 12V\'a yükseltir (HVDCP). QC 4 ve sonrasında USB-PD standardı da entegre edilmiştir.',
      'how_we_detect_title': 'Uygulama Nasıl Tespit Ediyor?',
      'how_we_detect_desc':
          'Cihazınız rootlu olduğunda veya kernel izin verdiğinde, telefonun şarj kontrolcüsünden (PMIC) /sys/class/power_supply/usb/real_type, pd_active ve quick_charge_type donanım kayıtları canlı okunur. Böylece şarj aletiyle yapılan protokol el sıkışması %100 kesinlikle gösterilir.',
      'protocol_registers': 'Donanım Kayıtları (Sysfs Dökümü)',
    },
    'en': {
      'app_title': 'Watt Meter',
      'how_to_continue': 'How would you like to continue?',
      'rooted_mode': 'Rooted Mode (Full Control)',
      'rootless_mode': 'Rootless Mode (Limited Data)',
      'checking_root': 'Checking Root Access...',
      'root_required': 'Root Access Required',
      'root_required_desc':
          'Watt Meter needs root access to access battery hardware information. Please grant permission via Magisk or KernelSU.',
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
      'cycles_count': '{} cycles',
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
      'root_status_not_found':
          'Root permission not granted, switching to rootless mode.',
      'turkish': 'Turkish',
      'english': 'English',
      'spanish': 'Spanish',
      'rooted': 'Rooted',
      'rootless': 'Rootless',
      'close': 'Close',
      'active': 'Active',
      'inactive': 'Inactive',
      'select_language': 'Select Language',
      'select_language_desc': 'Choose a language to continue',
      'continue_btn': 'Continue',
      'beta': 'BETA',
      'charging_protocol': 'Charging Protocol',
      'beta_warning_title': 'BETA FEATURE NOTICE',
      'protocol_beta_warning':
          'Charging protocol detection is currently in Beta. Depending on different SoCs (Qualcomm, MediaTek, Exynos, Tensor), custom ROMs, or kernel drivers, protocol results may vary or show inaccuracies.',
      'protocol_beta_warning_short':
          'Beta: Protocol detection may vary or contain inaccuracies depending on the device and kernel.',
      'pd_vs_qc_title': 'PD or QC?',
      'pmic_verified': 'PMIC Verified',
      'estimated_mode': 'Rootless Est.',
      'sub_mi_turbo_pps': 'USB-PD PPS + Mi Turbo Charge',
      'sub_mi_turbo': 'USB-PD Protocol Based Turbo Charge',
      'sub_pd_pps': 'USB Power Delivery 3.0 PPS (20mV Dynamic Voltage)',
      'sub_pd': 'USB Type-C Power Delivery (CC Digital Negotiation)',
      'sub_qc4': 'Qualcomm QC 4/4+ (USB-PD PPS Dual Standard)',
      'sub_qc3p': 'Qualcomm Quick Charge 3+ (HVDCP 3+)',
      'sub_qc3': 'Qualcomm Quick Charge 3.0 (200mV Stepped Voltage)',
      'sub_qc2': 'Qualcomm Quick Charge 2.0 (9V/12V Fixed High Voltage)',
      'sub_qc': 'Qualcomm HVDCP Fast Charging',
      'sub_supervooc': 'SuperVOOC / Warp / Dart High Current Tech',
      'sub_samsung_afc': 'Samsung Fast Charge (AFC 15W)',
      'sub_dcp': 'Dedicated Charging Port (Standard 5V Adapter)',
      'sub_wireless': 'Wireless Induction Charging (Qi Standard)',
      'sub_slow_usb': 'Standard USB / PC Data Port (500mA - 900mA)',
      'sub_est_ultra': '~{}W Power (Likely PD PPS / Turbo)',
      'title_est_fast': 'Fast Charge (PD / QC)',
      'sub_est_fast': '~{}W Fast Charge (USB-PD or QC Compatible)',
      'sub_est_dcp': '~{}W Standard Fast Charge',
      'sub_est_slow': '~{}W Low Power (Standard USB)',
      'ladder_pd_active': '⚡ USB-PD ACTIVE',
      'ladder_qc_active': '⚡ QUALCOMM QC ACTIVE',
      'status_active_fmt': 'Active ({})',
      'status_disabled': 'Disabled (0)',
      'status_hardware': 'Active (Hardware)',
      'line_volt_fmt': '{} V (Line)',
      'volt_standard': '~5.0 V (Standard)',
      'volt_qc_hvdcp': '~9.0 V (QC HVDCP)',
      'volt_pd_high': '~9.0V - 15.0V (PD)',
      'volt_pd_profile': '~9.0 V (PD Profile)',
      'pmic_read': 'READ',
      'pmic_rootless': 'ROOTLESS',
      'protocol_pd': 'USB Power Delivery (PD)',
      'protocol_pd_pps': 'USB-PD PPS (Dynamic Voltage)',
      'protocol_qc': 'Qualcomm Quick Charge (QC)',
      'protocol_qc2': 'Qualcomm Quick Charge 2.0 (QC 2.0)',
      'protocol_qc3': 'Qualcomm Quick Charge 3.0 (QC 3.0)',
      'protocol_qc3p': 'Qualcomm Quick Charge 3+ (QC 3+)',
      'protocol_qc4': 'Qualcomm Quick Charge 4/4+ (PD PPS)',
      'protocol_mi_turbo': 'Mi Turbo Charge / HyperCharge',
      'protocol_supervooc': 'SuperVOOC / Warp / Dart',
      'protocol_samsung_afc': 'Samsung Fast Charge (AFC)',
      'protocol_dcp': 'Standard Fast Charger (DCP 5V)',
      'protocol_sdp_cdp': 'Standard USB Port (PC / Slow)',
      'protocol_wireless': 'Wireless Charging (Qi)',
      'protocol_discharging': 'Discharging (Battery Power)',
      'protocol_unknown': 'Detecting Protocol...',
      'active_connection': 'ACTIVE CONNECTION',
      'inactive_connection': 'DISCONNECTED',
      'pd_status': 'PD Status',
      'qc_status': 'QC Status',
      'pmic_register': 'PMIC Register',
      'line_voltage': 'Input / Line Voltage',
      'speed_level': 'Charging Speed Level',
      'speed_slow': 'Slow Charge',
      'speed_normal': 'Normal Charge',
      'speed_fast': 'Fast Charge',
      'speed_super': 'Super Fast',
      'speed_ultra': 'Ultra / Turbo',
      'step_standard_5v': 'Standard 5V',
      'step_qualcomm_qc': 'Qualcomm QC',
      'step_usb_pd': 'USB-PD',
      'step_pd_pps_turbo': 'PD-PPS / Turbo',
      'info_sheet_title': 'Charging Protocols: PD vs QC',
      'info_sheet_subtitle': 'About Your Phone\'s Charging Technology',
      'what_is_pd_title': 'What is USB Power Delivery (PD)?',
      'what_is_pd_desc':
          'A universal Type-C standard developed by the USB Implementers Forum. Devices digitally negotiate power profiles over CC pins. Supports 5V, 9V, 12V, 15V, 20V, and PPS (20mV steps) to minimize heating. Used across modern Android and iPhone devices.',
      'what_is_qc_title': 'What is Qualcomm Quick Charge (QC)?',
      'what_is_qc_desc':
          'A proprietary high-voltage charging technology developed by Qualcomm for Snapdragon devices. It increases voltage from 5V to 9V or 12V over USB D+/D- data pins (HVDCP). QC 4 and later also integrate the USB-PD standard.',
      'how_we_detect_title': 'How Does the App Detect It?',
      'how_we_detect_desc':
          'With root access or when kernel permits, hardware registers like /sys/class/power_supply/usb/real_type, pd_active, and quick_charge_type are read directly from the phone\'s PMIC. This reveals the exact hardware handshake between the charger and phone with 100% accuracy.',
      'protocol_registers': 'Hardware Registers (Sysfs Dump)',
    },
    'es': {
      'app_title': 'Watt Meter',
      'how_to_continue': '¿Cómo desea continuar?',
      'rooted_mode': 'Modo Root (Control total)',
      'rootless_mode': 'Modo Sin Root (Datos limitados)',
      'checking_root': 'Verificando acceso root...',
      'root_required': 'Acceso root requerido',
      'root_required_desc': 'Watt Meter necesita acceso root para acceder a la información del hardware de la batería. Conceda permiso mediante Magisk o KernelSU.',
      'retry_root': 'Solicitar acceso root / Reintentar',
      'root_active': 'ROOT ACTIVO',
      'rootless_active': 'MODO SIN ROOT',
      'charge_watt': 'VATIOS DE CARGA',
      'discharge_watt': 'VATIOS DE DESCARGA',
      'current_charge': 'Corriente (Carga)',
      'current_discharge': 'Corriente (Descarga)',
      'voltage': 'Voltaje',
      'capacity': 'Capacidad',
      'charge_percentage': 'Nivel',
      'unknown': 'Desconocido',
      'battery_temp': 'Temperatura de la batería',
      'charge_time_est': 'Tiempo restante estimado',
      'full': 'Completamente cargado',
      'almost_full': 'Casi lleno',
      'not_charging': 'No está cargando',
      'cannot_calculate': 'No se puede calcular',
      'full_in_mins': 'Carga completa en {} min',
      'battery_health': 'Salud / Vida útil de la batería',
      'cycles_count': '{} ciclos',
      'device_info': 'Información del dispositivo',
      'model': 'Modelo',
      'android_version': 'Versión de Android',
      'rom_version': 'Versión de ROM',
      'charge_limiter': 'Limitador de velocidad de carga (Beta)',
      'manual_ma': 'Manual (mA)',
      'example_ma': 'Ej.: 2000',
      'apply': 'APLICAR',
      'quick_limits': 'Límites rápidos (Estimado por valor de vatios):',
      'reset': 'RESTABLECER',
      'limit_reset_msg': 'Límite de carga restablecido',
      'limit_set_msg': 'Límite ajustado a {} mA',
      'limit_watt_set_msg': 'Límite ajustado a {}W (~{} mA)',
      'settings': 'Ajustes',
      'language': 'Idioma',
      'working_mode': 'Modo de trabajo',
      'save': 'Guardar',
      'mode_changed_msg': 'Modo de trabajo cambiado, actualizando aplicación',
      'root_status_not_found': 'Permiso root no concedido, cambiando a modo sin root.',
      'turkish': 'Turco',
      'english': 'Inglés',
      'spanish': 'Español',
      'rooted': 'Con Root',
      'rootless': 'Sin Root',
      'close': 'Cerrar',
      'active': 'Activo',
      'inactive': 'Inactivo',
      'select_language': 'Seleccionar idioma',
      'select_language_desc': 'Elija un idioma para continuar',
      'continue_btn': 'Continuar',
      'beta': 'BETA',
      'charging_protocol': 'Protocolo de carga',
      'beta_warning_title': 'AVISO DE FUNCIÓN BETA',
      'protocol_beta_warning': 'La detección del protocolo de carga está actualmente en fase Beta. Según el SoC (Qualcomm, MediaTek, Exynos, Tensor), ROM personalizada o controladores del kernel, los resultados del protocolo pueden variar o mostrar imprecisiones.',
      'protocol_beta_warning_short': 'Beta: La detección del protocolo puede variar o contener imprecisiones según el dispositivo y el kernel.',
      'pd_vs_qc_title': '¿PD o QC?',
      'pmic_verified': 'PMIC verificado',
      'estimated_mode': 'Estimación sin root',
      'sub_mi_turbo_pps': 'USB-PD PPS + Mi Turbo Charge',
      'sub_mi_turbo': 'Carga turbo basada en protocolo USB-PD',
      'sub_pd_pps': 'USB Power Delivery 3.0 PPS (Voltaje dinámico de 20mV)',
      'sub_pd': 'USB Type-C Power Delivery (Negociación digital CC)',
      'sub_qc4': 'Qualcomm QC 4/4+ (Estándar dual USB-PD PPS)',
      'sub_qc3p': 'Qualcomm Quick Charge 3+ (HVDCP 3+)',
      'sub_qc3': 'Qualcomm Quick Charge 3.0 (Voltaje escalonado de 200mV)',
      'sub_qc2': 'Qualcomm Quick Charge 2.0 (Alto voltaje fijo de 9V/12V)',
      'sub_qc': 'Carga rápida Qualcomm HVDCP',
      'sub_supervooc': 'Tecnología de alta corriente SuperVOOC / Warp / Dart',
      'sub_samsung_afc': 'Samsung Carga Rápida (AFC 15W)',
      'sub_dcp': 'Puerto de carga dedicado (Adaptador estándar de 5V)',
      'sub_wireless': 'Carga por inducción inalámbrica (Estándar Qi)',
      'sub_slow_usb': 'Puerto de datos USB estándar / PC (500mA - 900mA)',
      'sub_est_ultra': '~{}W Potencia (Probable PD PPS / Turbo)',
      'title_est_fast': 'Carga rápida (PD / QC)',
      'sub_est_fast': '~{}W Carga rápida (Compatible con USB-PD o QC)',
      'sub_est_dcp': '~{}W Carga rápida estándar',
      'sub_est_slow': '~{}W Baja potencia (USB estándar)',
      'ladder_pd_active': '⚡ USB-PD ACTIVO',
      'ladder_qc_active': '⚡ QUALCOMM QC ACTIVO',
      'status_active_fmt': 'Activo ({})',
      'status_disabled': 'Desactivado (0)',
      'status_hardware': 'Activo (Hardware)',
      'line_volt_fmt': '{} V (Línea)',
      'volt_standard': '~5.0 V (Estándar)',
      'volt_qc_hvdcp': '~9.0 V (QC HVDCP)',
      'volt_pd_high': '~9.0V - 15.0V (PD)',
      'volt_pd_profile': '~9.0 V (Perfil PD)',
      'pmic_read': 'LEÍDO',
      'pmic_rootless': 'SIN ROOT',
      'protocol_pd': 'USB Power Delivery (PD)',
      'protocol_pd_pps': 'USB-PD PPS (Voltaje dinámico)',
      'protocol_qc': 'Qualcomm Quick Charge (QC)',
      'protocol_qc2': 'Qualcomm Quick Charge 2.0 (QC 2.0)',
      'protocol_qc3': 'Qualcomm Quick Charge 3.0 (QC 3.0)',
      'protocol_qc3p': 'Qualcomm Quick Charge 3+ (QC 3+)',
      'protocol_qc4': 'Qualcomm Quick Charge 4/4+ (PD PPS)',
      'protocol_mi_turbo': 'Mi Turbo Charge / HyperCharge',
      'protocol_supervooc': 'SuperVOOC / Warp / Dart',
      'protocol_samsung_afc': 'Carga rápida Samsung (AFC)',
      'protocol_dcp': 'Cargador rápido estándar (DCP 5V)',
      'protocol_sdp_cdp': 'Puerto USB estándar (PC / Lento)',
      'protocol_wireless': 'Carga inalámbrica (Qi)',
      'protocol_discharging': 'Descargando (Energía de batería)',
      'protocol_unknown': 'Detectando protocolo...',
      'active_connection': 'CONEXIÓN ACTIVA',
      'inactive_connection': 'DESCONECTADO',
      'pd_status': 'Estado PD',
      'qc_status': 'Estado QC',
      'pmic_register': 'Registro PMIC',
      'line_voltage': 'Voltaje de entrada / línea',
      'speed_level': 'Nivel de velocidad de carga',
      'speed_slow': 'Carga lenta',
      'speed_normal': 'Carga normal',
      'speed_fast': 'Carga rápida',
      'speed_super': 'Súper rápida',
      'speed_ultra': 'Ultra / Turbo',
      'step_standard_5v': 'Estándar 5V',
      'step_qualcomm_qc': 'Qualcomm QC',
      'step_usb_pd': 'USB-PD',
      'step_pd_pps_turbo': 'PD-PPS / Turbo',
      'info_sheet_title': 'Protocolos de carga: PD vs QC',
      'info_sheet_subtitle': 'Acerca de la tecnología de carga de su teléfono',
      'what_is_pd_title': '¿Qué es USB Power Delivery (PD)?',
      'what_is_pd_desc': 'Un estándar universal Tipo C desarrollado por el USB Implementers Forum. Los dispositivos negocian perfiles de energía digitalmente a través de pines CC. Admite 5V, 9V, 12V, 15V, 20V y PPS (pasos de 20mV) para minimizar el calentamiento. Se utiliza en todos los dispositivos Android e iPhone modernos.',
      'what_is_qc_title': '¿Qué es Qualcomm Quick Charge (QC)?',
      'what_is_qc_desc': 'Una tecnología patentada de carga de alto voltaje desarrollada por Qualcomm para dispositivos Snapdragon. Aumenta el voltaje de 5V a 9V o 12V a través de líneas de datos USB D+/D- (HVDCP). QC 4 y posteriores también integran el estándar USB-PD.',
      'how_we_detect_title': '¿Cómo lo detecta la aplicación?',
      'how_we_detect_desc': 'Con acceso root o cuando el kernel lo permite, los registros de hardware como /sys/class/power_supply/usb/real_type, pd_active y quick_charge_type se leen directamente del PMIC del teléfono. Esto muestra la negociación exacta de hardware entre el cargador y el teléfono con 100% de precisión.',
      'protocol_registers': 'Registros de hardware (Volcado Sysfs)',
    },
  };
}

String tr(String key, [List<String>? args]) =>
    LanguageManager.translate(key, args);

class SettingsManager {
  static late SharedPreferences _prefs;
  static final ValueNotifier<String?> workingModeNotifier = ValueNotifier(null);

  /// true = language selection screen was completed
  static final ValueNotifier<bool> languageSelectedNotifier = ValueNotifier(
    false,
  );

  /// true = root check passed; used by AppHomeRouter to show Dashboard(isRooted:true)
  static final ValueNotifier<bool> rootConfirmedNotifier = ValueNotifier(false);

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Default language is English; only override if user has explicitly saved one
    final lang = _prefs.getString('language') ?? 'en';
    LanguageManager.setLocale(lang);
    languageSelectedNotifier.value =
        _prefs.getBool('language_selected') ?? false;
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
echo "charge_full=$(cat /sys/class/power_supply/bms/charge_full 2>/dev/null || cat /sys/class/power_supply/battery/charge_full 2>/dev/null || cat /sys/class/qcom-battery/fg1_fcc 2>/dev/null || echo '0')"
echo "charge_full_design=$(cat /sys/class/power_supply/bms/charge_full_design 2>/dev/null || cat /sys/class/power_supply/battery/charge_full_design 2>/dev/null || echo '0')"
echo "status=$(cat /sys/class/power_supply/battery/status 2>/dev/null || echo 'Unknown')"
echo "batt_temp=$(cat /sys/class/power_supply/battery/temp 2>/dev/null || cat /sys/class/qcom-battery/bq2597x_battery_temp 2>/dev/null || echo '0')"
ZONE=$(grep -li 'cpu' /sys/class/thermal/thermal_zone*/type 2>/dev/null | head -n 1)
if [ -n "$ZONE" ]; then
  TEMP_FILE=$(echo "$ZONE" | sed 's/type/temp/')
  echo "cpu_temp=$(cat "$TEMP_FILE" 2>/dev/null || echo '0')"
else
  echo "cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo '0')"
fi

REAL_TYPE=$(cat /sys/class/power_supply/usb/real_type 2>/dev/null || cat /sys/class/qcom-battery/real_type 2>/dev/null || cat /sys/class/qcom-battery/usb_real_type 2>/dev/null || echo '')
if [ -z "$REAL_TYPE" ]; then
  REAL_TYPE=$(sed -n 's/.*\[\([^]]*\)\].*/\1/p' /sys/class/power_supply/usb/usb_type 2>/dev/null)
fi
echo "usb_real_type=$REAL_TYPE"
echo "usb_type=$(cat /sys/class/power_supply/usb/type 2>/dev/null || echo '')"

PD_SUP=$(cat /sys/class/typec/port0-partner/supports_usb_power_delivery 2>/dev/null || echo '')
PWR_OP=$(cat /sys/class/typec/port0/pwr_opmode 2>/dev/null || cat /sys/class/typec/port0/power_operation_mode 2>/dev/null || echo '')
PD_ACT=$(cat /sys/class/power_supply/usb/pd_active 2>/dev/null || echo '')
if [ -z "$PD_ACT" ]; then
  if [ "$PD_SUP" = "yes" ] || [ "$PWR_OP" = "usb_power_delivery" ] || [ "$REAL_TYPE" = "PD" ] || [ "$REAL_TYPE" = "PD_PPS" ]; then
    PD_ACT="1"
  elif [ "$PD_SUP" = "no" ] || [ "$REAL_TYPE" = "SDP" ] || [ "$REAL_TYPE" = "DCP" ] || [ "$REAL_TYPE" = "CDP" ]; then
    PD_ACT="0"
  fi
fi
echo "pd_active=$PD_ACT"
echo "pd_allowed=$(cat /sys/class/power_supply/usb/pd_allowed 2>/dev/null || echo '')"
echo "quick_charge_type=$(cat /sys/class/power_supply/usb/quick_charge_type 2>/dev/null || cat /sys/class/power_supply/usb/hvdcp3_type 2>/dev/null || cat /sys/class/qcom-battery/quick_charge_type 2>/dev/null || echo '')"
echo "typec_mode=$(cat /sys/class/power_supply/usb/typec_mode 2>/dev/null || cat /sys/class/qcom-battery/typec_mode 2>/dev/null || echo '')"
echo "pwr_opmode=$PWR_OP"
echo "usb_voltage_now=$(cat /sys/class/power_supply/usb/voltage_now 2>/dev/null || cat /sys/class/qcom-battery/bq2597x_bus_voltage 2>/dev/null || cat /sys/class/power_supply/usb/input_voltage_regulation 2>/dev/null || echo '')"
echo "usb_voltage_max=$(cat /sys/class/power_supply/usb/voltage_max 2>/dev/null || echo '')"
echo "usb_current_max=$(cat /sys/class/power_supply/usb/current_max 2>/dev/null || cat /sys/class/power_supply/usb/input_current_limit 2>/dev/null || cat /sys/class/power_supply/usb/hw_current_max 2>/dev/null || cat /sys/class/power_supply/usb/pd_current_max 2>/dev/null || echo '')"
echo "charger_type=$(cat /sys/class/power_supply/usb/charger_type 2>/dev/null || cat /sys/class/power_supply/battery/charger_type 2>/dev/null || cat /sys/class/power_supply/main/charger_type 2>/dev/null || echo '')"
echo "charge_type=$(cat /sys/class/power_supply/battery/charge_type 2>/dev/null || cat /sys/class/power_supply/main/charge_type 2>/dev/null || echo '')"
echo "fastcharge_mode=$(cat /sys/class/power_supply/battery/fastcharge_mode 2>/dev/null || cat /sys/class/power_supply/battery/sub_fastcharge_mode 2>/dev/null || cat /sys/class/qcom-battery/fastchg_mode 2>/dev/null || echo '')"
echo "turbo_mode=$(cat /sys/class/power_supply/battery/turbo_mode 2>/dev/null || cat /sys/class/power_supply/battery/super_charging_mode 2>/dev/null || cat /sys/class/qcom-battery/fg1_fastcharge 2>/dev/null || echo '')"
echo "adapter_power=$(cat /sys/class/power_supply/battery/adapter_power 2>/dev/null || cat /sys/class/qcom-battery/power_max 2>/dev/null || echo '')"
echo "adapter_svid=$(cat /sys/class/qcom-battery/adapter_svid 2>/dev/null || echo '')"
echo "adapter_id=$(cat /sys/class/qcom-battery/adapter_id 2>/dev/null || echo '')"
echo "vooc_mode=$(cat /sys/class/power_supply/battery/vooc_mode 2>/dev/null || cat /sys/class/power_supply/battery/fast_chg_type 2>/dev/null || echo '')"
echo "sec_charger_type=$(cat /sys/class/power_supply/battery/charger_type 2>/dev/null || cat /sys/class/power_supply/battery/sec_battery 2>/dev/null || echo '')"
echo "soh=$(cat /sys/class/qcom-battery/soh 2>/dev/null || cat /sys/class/qcom-battery/fg1_soh 2>/dev/null || echo '')"
echo "soc_decimal=$(cat /sys/class/qcom-battery/soc_decimal 2>/dev/null || echo '')"
echo "cycle_count=$(cat /sys/class/power_supply/battery/cycle_count 2>/dev/null || cat /sys/class/qcom-battery/fg1_cycle 2>/dev/null || echo '')"

for p in /sys/class/power_supply/*; do
  if [ -d "$p" ]; then
    psname=$(basename "$p")
    for prop in real_type pd_active quick_charge_type charger_type charge_type; do
      if [ -f "$p/$prop" ]; then
        v=$(cat "$p/$prop" 2>/dev/null)
        if [ -n "$v" ]; then
          echo "ps_${psname}_${prop}=${v}"
        fi
      fi
    done
  fi
done

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
            /sys/class/power_supply/battery/constant_charge_current \\
            /sys/class/power_supply/battery/current_max \\
            /sys/class/power_supply/main/constant_charge_current_max \\
            /sys/class/power_supply/usb/input_current_limit \\
            /sys/class/power_supply/usb/current_max \\
            /sys/class/power_supply/usb/hw_current_max \\
            /sys/class/power_supply/usb/pd_current_max \\
            /sys/class/power_supply/pc_port/current_max \\
            /sys/class/qcom-battery/restrict_cur; do
  if [ -f "\$file" ]; then
    chmod 644 "\$file" 2>/dev/null
    echo $microAmps > "\$file" 2>/dev/null
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
            /sys/class/power_supply/battery/constant_charge_current \\
            /sys/class/power_supply/battery/current_max \\
            /sys/class/power_supply/main/constant_charge_current_max \\
            /sys/class/power_supply/usb/input_current_limit \\
            /sys/class/power_supply/usb/current_max \\
            /sys/class/power_supply/usb/hw_current_max \\
            /sys/class/power_supply/usb/pd_current_max \\
            /sys/class/power_supply/pc_port/current_max \\
            /sys/class/qcom-battery/restrict_cur; do
  if [ -f "\$file" ]; then
    chmod 644 "\$file" 2>/dev/null
    echo 30000000 > "\$file" 2>/dev/null
  fi
done
if [ -f /sys/class/power_supply/battery/charge_control_limit ]; then
  chmod 644 /sys/class/power_supply/battery/charge_control_limit 2>/dev/null
  echo 0 > /sys/class/power_supply/battery/charge_control_limit 2>/dev/null
fi
''';
    await Process.run('su', ['-c', script]);
  }
}

enum ChargingProtocolType {
  discharging,
  usbPd,
  usbPdPps,
  qualcommQc,
  qualcommQc2,
  qualcommQc3,
  qualcommQc3Plus,
  qualcommQc4,
  miTurbo,
  superVooc,
  samsungAfc,
  standardDcp,
  slowUsb,
  wireless,
  unknown,
}

enum ChargingSpeedLevel {
  none,
  slow,
  normal,
  fast,
  superFast,
  ultraFast,
}

class ChargingProtocolInfo {
  final ChargingProtocolType protocolType;
  final ChargingSpeedLevel speedLevel;
  final String title;
  final String subtitle;
  final String code;
  final bool isPd;
  final bool isQc;
  final bool isVerifiedHardware;
  final int activeLadderStep; // 0: None, 1: Standart 5V, 2: Qualcomm QC, 3: USB-PD, 4: PD-PPS / Turbo
  final String inputVoltageStr;
  final String pdStatusText;
  final String qcStatusText;
  final String pmicRegisterText;
  final Color accentColor;
  final IconData icon;
  final Map<String, String> debugRegisters;

  ChargingProtocolInfo({
    required this.protocolType,
    required this.speedLevel,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.isPd,
    required this.isQc,
    required this.isVerifiedHardware,
    required this.activeLadderStep,
    required this.inputVoltageStr,
    required this.pdStatusText,
    required this.qcStatusText,
    required this.pmicRegisterText,
    required this.accentColor,
    required this.icon,
    required this.debugRegisters,
  });

  factory ChargingProtocolInfo.discharging() {
    return ChargingProtocolInfo(
      protocolType: ChargingProtocolType.discharging,
      speedLevel: ChargingSpeedLevel.none,
      title: tr('protocol_discharging'),
      subtitle: tr('not_charging'),
      code: 'DISCHARGING',
      isPd: false,
      isQc: false,
      isVerifiedHardware: false,
      activeLadderStep: 0,
      inputVoltageStr: '-',
      pdStatusText: tr('inactive'),
      qcStatusText: tr('inactive'),
      pmicRegisterText: '-',
      accentColor: const Color(0xFF64748B),
      icon: Icons.power_off_rounded,
      debugRegisters: {},
    );
  }

  factory ChargingProtocolInfo.analyze({
    required bool isCharging,
    required double wattageW,
    required double voltageV,
    required int currentMA,
    required Map<String, String> rawStats,
  }) {
    if (!isCharging) {
      return ChargingProtocolInfo.discharging();
    }

    final pdActive =
        (rawStats['pd_active'] ?? rawStats['ps_usb_pd_active'] ?? '').trim();
    final realType = (rawStats['usb_real_type'] ??
            rawStats['ps_usb_real_type'] ??
            rawStats['real_type'] ??
            rawStats['usb_real_type_qcom'] ??
            rawStats['usb_real_type_qcom2'] ??
            '')
        .trim()
        .toUpperCase();
    final qcType = (rawStats['quick_charge_type'] ??
            rawStats['ps_usb_quick_charge_type'] ??
            rawStats['quick_charge_type_qcom'] ??
            rawStats['hvdcp3_type'] ??
            '')
        .trim();
    final typecMode = (rawStats['typec_mode'] ?? rawStats['typec_mode_qcom'] ?? '').trim().toUpperCase();
    final pwrOpMode = (rawStats['pwr_opmode'] ??
            rawStats['power_operation_mode'] ??
            '')
        .trim()
        .toLowerCase();
    final chargerType = (rawStats['charger_type'] ??
            rawStats['usb_charger_type'] ??
            rawStats['sec_charger_type'] ??
            '')
        .trim()
        .toUpperCase();
    final chargeType = (rawStats['charge_type'] ?? '').trim();
    final fastchargeMode = (rawStats['fastcharge_mode'] ?? rawStats['fastcharge_mode_qcom'] ?? '').trim();
    final turboMode = (rawStats['turbo_mode'] ?? rawStats['turbo_mode_qcom'] ?? '').trim();
    final adapterPower = (rawStats['adapter_power'] ?? '').trim();
    final adapterSvid = (rawStats['adapter_svid'] ?? '').trim();
    final voocMode = (rawStats['vooc_mode'] ?? '').trim();
    final plugged = (rawStats['plugged'] ?? '').trim();

    String dynamicPsRealType = '';
    String dynamicPsPdActive = '';
    String dynamicPsQcType = '';
    for (final entry in rawStats.entries) {
      final k = entry.key.toLowerCase();
      if (k.startsWith('ps_') &&
          k.endsWith('_real_type') &&
          entry.value.trim().isNotEmpty) {
        dynamicPsRealType = entry.value.trim().toUpperCase();
      }
      if (k.startsWith('ps_') &&
          k.endsWith('_pd_active') &&
          entry.value.trim().isNotEmpty) {
        dynamicPsPdActive = entry.value.trim();
      }
      if (k.startsWith('ps_') &&
          k.endsWith('_quick_charge_type') &&
          entry.value.trim().isNotEmpty) {
        dynamicPsQcType = entry.value.trim();
      }
    }

    final effectiveRealType =
        realType.isNotEmpty ? realType : dynamicPsRealType;
    final effectivePdActive =
        pdActive.isNotEmpty ? pdActive : dynamicPsPdActive;
    final effectiveQcType = qcType.isNotEmpty ? qcType : dynamicPsQcType;

    double? lineVoltage;
    final rawUsbV = double.tryParse(rawStats['usb_voltage_now'] ?? '') ?? 0.0;
    if (rawUsbV > 100000) {
      lineVoltage = rawUsbV / 1000000.0;
    } else if (rawUsbV > 100) {
      lineVoltage = rawUsbV / 1000.0;
    } else if (rawUsbV > 1.0) {
      lineVoltage = rawUsbV;
    }

    ChargingSpeedLevel speedLevel;
    if (wattageW < 7.5) {
      speedLevel = ChargingSpeedLevel.slow;
    } else if (wattageW < 15.0) {
      speedLevel = ChargingSpeedLevel.normal;
    } else if (wattageW < 27.0) {
      speedLevel = ChargingSpeedLevel.fast;
    } else if (wattageW < 45.0) {
      speedLevel = ChargingSpeedLevel.superFast;
    } else {
      speedLevel = ChargingSpeedLevel.ultraFast;
    }

    final bool hasHardwareIndicators = effectivePdActive.isNotEmpty ||
        effectiveRealType.isNotEmpty ||
        effectiveQcType.isNotEmpty ||
        pwrOpMode.isNotEmpty ||
        typecMode.isNotEmpty ||
        turboMode.isNotEmpty;

    bool isPd = false;
    bool isPps = false;
    bool isQc = false;
    ChargingProtocolType protocolType = ChargingProtocolType.unknown;
    String title = '';
    String subtitle = '';
    String code = effectiveRealType.isNotEmpty ? effectiveRealType : 'CHARGING';
    int ladderStep = 1;
    Color accent = const Color(0xFF38BDF8);
    IconData icon = Icons.bolt_rounded;

    final bool pdCondition = effectivePdActive == '1' ||
        effectiveRealType.contains('PD') ||
        pwrOpMode.contains('usb_power_delivery') ||
        typecMode.contains('POWER_DELIVERY') ||
        chargerType.contains('PD');

    final bool qcCondition = effectiveRealType.contains('HVDCP') ||
        effectiveRealType.contains('QC') ||
        (effectiveQcType.isNotEmpty && effectiveQcType != '0') ||
        chargerType.contains('QC') ||
        chargerType.contains('HVDCP');

    final bool turboCondition = turboMode == '1' ||
        fastchargeMode == '1' ||
        fastchargeMode == '2' ||
        adapterPower == '33' ||
        adapterPower == '67' ||
        adapterPower == '90' ||
        adapterPower == '120' ||
        (adapterSvid == '2717' && wattageW > 15.0) ||
        effectiveRealType.contains('TURBO') ||
        effectiveRealType.contains('HYPER');

    if (pdCondition) {
      isPd = true;
      if (effectiveRealType.contains('PPS') ||
          chargerType.contains('PPS') ||
          effectiveQcType == '4') {
        isPps = true;
      }

      if (turboCondition) {
        protocolType = ChargingProtocolType.miTurbo;
        title = tr('protocol_mi_turbo');
        subtitle = isPps
            ? tr('sub_mi_turbo_pps')
            : tr('sub_mi_turbo');
        code =
            effectiveRealType.isNotEmpty ? effectiveRealType : 'MI_TURBO_PD';
        ladderStep = 4;
        accent = const Color(0xFFA855F7);
        icon = Icons.flash_on_rounded;
      } else if (isPps) {
        protocolType = ChargingProtocolType.usbPdPps;
        title = tr('protocol_pd_pps');
        subtitle = tr('sub_pd_pps');
        code =
            effectiveRealType.isNotEmpty ? effectiveRealType : 'USB_PD_PPS';
        ladderStep = 4;
        accent = const Color(0xFF38BDF8);
        icon = Icons.electric_bolt_rounded;
      } else {
        protocolType = ChargingProtocolType.usbPd;
        title = tr('protocol_pd');
        subtitle = tr('sub_pd');
        code = effectiveRealType.isNotEmpty ? effectiveRealType : 'USB_PD';
        ladderStep = 3;
        accent = const Color(0xFF38BDF8);
        icon = Icons.bolt_rounded;
      }
    } else if (qcCondition) {
      isQc = true;
      accent = const Color(0xFFF97316);
      icon = Icons.offline_bolt_rounded;

      if (effectiveQcType == '4') {
        isPd = true;
        protocolType = ChargingProtocolType.qualcommQc4;
        title = tr('protocol_qc4');
        subtitle = tr('sub_qc4');
        code = 'QC_4_PPS';
        ladderStep = 4;
        accent = const Color(0xFF818CF8);
      } else if (effectiveRealType.contains('3P5') || effectiveQcType == '3') {
        protocolType = ChargingProtocolType.qualcommQc3Plus;
        title = tr('protocol_qc3p');
        subtitle = tr('sub_qc3p');
        code =
            effectiveRealType.isNotEmpty ? effectiveRealType : 'QC_3_PLUS';
        ladderStep = 2;
      } else if (effectiveRealType.contains('HVDCP_3') ||
          effectiveQcType == '2') {
        protocolType = ChargingProtocolType.qualcommQc3;
        title = tr('protocol_qc3');
        subtitle = tr('sub_qc3');
        code =
            effectiveRealType.isNotEmpty ? effectiveRealType : 'USB_HVDCP_3';
        ladderStep = 2;
      } else if (effectiveRealType.contains('HVDCP') ||
          effectiveQcType == '1') {
        protocolType = ChargingProtocolType.qualcommQc2;
        title = tr('protocol_qc2');
        subtitle = tr('sub_qc2');
        code =
            effectiveRealType.isNotEmpty ? effectiveRealType : 'USB_HVDCP';
        ladderStep = 2;
      } else {
        protocolType = ChargingProtocolType.qualcommQc;
        title = tr('protocol_qc');
        subtitle = tr('sub_qc');
        code =
            effectiveRealType.isNotEmpty ? effectiveRealType : 'QC_HVDCP';
        ladderStep = 2;
      }
    } else if (voocMode.isNotEmpty && voocMode != '0') {
      protocolType = ChargingProtocolType.superVooc;
      title = tr('protocol_supervooc');
      subtitle = tr('sub_supervooc');
      code = 'SUPERVOOC';
      ladderStep = 4;
      accent = const Color(0xFFEF4444);
      icon = Icons.flash_on_rounded;
    } else if (chargerType.contains('SEC_BATTERY_CABLE_TA') ||
        chargerType.contains('AFC')) {
      protocolType = ChargingProtocolType.samsungAfc;
      title = tr('protocol_samsung_afc');
      subtitle = tr('sub_samsung_afc');
      code = 'SAMSUNG_AFC';
      ladderStep = 2;
      accent = const Color(0xFF06B6D4);
      icon = Icons.bolt_rounded;
    } else if (effectiveRealType == 'USB_DCP' ||
        effectiveRealType == 'DCP' ||
        chargerType.contains('DCP')) {
      protocolType = ChargingProtocolType.standardDcp;
      title = tr('protocol_dcp');
      subtitle = tr('sub_dcp');
      code = 'USB_DCP';
      ladderStep = 1;
      accent = const Color(0xFF10B981);
      icon = Icons.power_rounded;
    } else if (effectiveRealType == 'WIRELESS' || plugged == 'Wireless') {
      protocolType = ChargingProtocolType.wireless;
      title = tr('protocol_wireless');
      subtitle = tr('sub_wireless');
      code = 'WIRELESS';
      ladderStep = 1;
      accent = const Color(0xFF8B5CF6);
      icon = Icons.wifi_protected_setup_rounded;
    } else if (effectiveRealType == 'USB_SDP' ||
        effectiveRealType == 'SDP' ||
        effectiveRealType == 'USB_CDP' ||
        effectiveRealType == 'CDP' ||
        plugged == 'USB') {
      protocolType = ChargingProtocolType.slowUsb;
      title = tr('protocol_sdp_cdp');
      subtitle = tr('sub_slow_usb');
      code = effectiveRealType.isNotEmpty
          ? (effectiveRealType.startsWith('USB_')
              ? effectiveRealType
              : 'USB_$effectiveRealType')
          : 'USB_SDP';
      ladderStep = 1;
      accent = const Color(0xFF64748B);
      icon = Icons.usb_rounded;
    } else {
      if (wattageW >= 27.0) {
        isPd = true;
        protocolType = ChargingProtocolType.usbPdPps;
        title = tr('protocol_pd_pps');
        subtitle = tr('sub_est_ultra', [wattageW.toStringAsFixed(1)]);
        code = 'EST_PD_PPS';
        ladderStep = 4;
        accent = const Color(0xFF38BDF8);
        icon = Icons.electric_bolt_rounded;
      } else if (wattageW >= 15.0) {
        protocolType = ChargingProtocolType.usbPd;
        title = tr('title_est_fast');
        subtitle = tr('sub_est_fast', [wattageW.toStringAsFixed(1)]);
        code = 'EST_FAST_CHG';
        ladderStep = 3;
        accent = const Color(0xFF38BDF8);
        icon = Icons.bolt_rounded;
      } else if (wattageW >= 7.5) {
        protocolType = ChargingProtocolType.standardDcp;
        title = tr('protocol_dcp');
        subtitle = tr('sub_est_dcp', [wattageW.toStringAsFixed(1)]);
        code = 'EST_DCP';
        ladderStep = 1;
        accent = const Color(0xFF10B981);
        icon = Icons.power_rounded;
      } else {
        protocolType = ChargingProtocolType.slowUsb;
        title = tr('protocol_sdp_cdp');
        subtitle = tr('sub_est_slow', [wattageW.toStringAsFixed(1)]);
        code = 'EST_SLOW';
        ladderStep = 1;
        accent = const Color(0xFF64748B);
        icon = Icons.usb_rounded;
      }
    }

    String inputVoltageStr;
    if (lineVoltage != null && lineVoltage > 2.0) {
      inputVoltageStr = tr('line_volt_fmt', [lineVoltage.toStringAsFixed(1)]);
    } else if (isQc && wattageW > 12.0) {
      inputVoltageStr = tr('volt_qc_hvdcp');
    } else if (isPd && wattageW > 25.0) {
      inputVoltageStr = tr('volt_pd_high');
    } else if (isPd && wattageW > 14.0) {
      inputVoltageStr = tr('volt_pd_profile');
    } else {
      inputVoltageStr = tr('volt_standard');
    }

    String pdStatusText;
    if (effectivePdActive == '1') {
      pdStatusText = isPps
          ? tr('status_active_fmt', ['PD 3.0 PPS'])
          : tr('status_active_fmt', ['USB-PD']);
    } else if (isPd) {
      pdStatusText = tr('status_hardware');
    } else if (effectivePdActive == '0') {
      pdStatusText = tr('status_disabled');
    } else {
      pdStatusText = '-';
    }

    String qcStatusText;
    if (effectiveQcType == '1') {
      qcStatusText = tr('status_active_fmt', ['QC 2.0']);
    } else if (effectiveQcType == '2') {
      qcStatusText = tr('status_active_fmt', ['QC 3.0']);
    } else if (effectiveQcType == '3') {
      qcStatusText = tr('status_active_fmt', ['QC 3+']);
    } else if (effectiveQcType == '4') {
      qcStatusText = tr('status_active_fmt', ['QC 4+']);
    } else if (isQc) {
      qcStatusText = tr('status_active_fmt', ['HVDCP']);
    } else if (effectiveQcType == '0') {
      qcStatusText = tr('status_disabled');
    } else {
      qcStatusText = '-';
    }

    String pmicRegisterText;
    if (effectiveRealType.isNotEmpty) {
      pmicRegisterText = effectiveRealType;
    } else if (pwrOpMode.isNotEmpty) {
      pmicRegisterText = pwrOpMode;
    } else if (chargerType.isNotEmpty) {
      pmicRegisterText = chargerType;
    } else {
      pmicRegisterText =
          hasHardwareIndicators ? tr('pmic_read') : tr('pmic_rootless');
    }

    return ChargingProtocolInfo(
      protocolType: protocolType,
      speedLevel: speedLevel,
      title: title,
      subtitle: subtitle,
      code: code,
      isPd: isPd,
      isQc: isQc,
      isVerifiedHardware: hasHardwareIndicators,
      activeLadderStep: ladderStep,
      inputVoltageStr: inputVoltageStr,
      pdStatusText: pdStatusText,
      qcStatusText: qcStatusText,
      pmicRegisterText: pmicRegisterText,
      accentColor: accent,
      icon: icon,
      debugRegisters: {
        'real_type': effectiveRealType,
        'pd_active': effectivePdActive,
        'quick_charge_type': effectiveQcType,
        'pwr_opmode': pwrOpMode,
        'typec_mode': typecMode,
        'charge_type': chargeType,
        'charger_type': chargerType,
        'turbo_mode': turboMode,
        'vooc_mode': voocMode,
        'plugged': plugged,
      },
    );
  }
}

class BatteryStats {
  final Map<String, String> rawStats;
  final String model;
  final String androidVer;
  final String rom;
  final String status;
  final int percentage;
  final String? socDecimal;
  final double voltageV;
  final double currentA;
  final int currentMA;
  final double wattageW;
  final int capacityMAh;
  final int designCapacityMAh;
  final double batteryHealth;
  final int? cycleCount;
  final double? hardwareSoh;
  final double cpuTempC;
  final double battTempC;
  final String timeRemainingStr;
  final bool isCharging;
  final bool isFull;
  final ChargingProtocolInfo protocolInfo;

  BatteryStats({
    required this.rawStats,
    required this.model,
    required this.androidVer,
    required this.rom,
    required this.status,
    required this.percentage,
    this.socDecimal,
    required this.voltageV,
    required this.currentA,
    required this.currentMA,
    required this.wattageW,
    required this.capacityMAh,
    required this.designCapacityMAh,
    required this.batteryHealth,
    this.cycleCount,
    this.hardwareSoh,
    required this.cpuTempC,
    required this.battTempC,
    required this.timeRemainingStr,
    required this.isCharging,
    required this.isFull,
    required this.protocolInfo,
  });

  factory BatteryStats.fromMap(
    Map<String, String> stats, {
    double? nativeBatteryTemp,
  }) {
    final marketName = stats['ro.product.marketname'] ??
        stats['ro.product.odm.marketname'] ??
        stats['ro.product.vendor.marketname'] ??
        stats['marketname'] ??
        stats['odm_marketname'] ??
        '';
    final rawModel = stats['ro.product.model'] ?? stats['model'] ?? '';

    String model = tr('unknown');
    if (marketName.isNotEmpty && rawModel.isNotEmpty) {
      if (marketName.toLowerCase().contains(rawModel.toLowerCase())) {
        model = marketName;
      } else {
        model = '$marketName ($rawModel)';
      }
    } else if (marketName.isNotEmpty) {
      model = marketName;
    } else if (rawModel.isNotEmpty) {
      model = rawModel;
    }

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
    final incProp = stats['ro.build.version.incremental'] ??
        stats['ro.mi.os.version.incremental'] ??
        stats['hyperos_incremental'] ??
        stats['build_incremental'] ??
        '';

    String romName = tr('unknown');
    String romVersion = '';

    if (romLower.contains('crdroid')) {
      romName = 'crDroid';
      romVersion =
          stats['ro.crdroid.build.version'] ??
          stats['ro.crdroid.version'] ??
          '';
    } else if (romLower.contains('hyperos') ||
        (stats['ro.mi.os.version.name']?.isNotEmpty ?? false) ||
        incProp.startsWith('OS')) {
      romName = 'HyperOS';
      final baseName = stats['ro.mi.os.version.name'] ?? '';
      if (incProp.isNotEmpty) {
        final match = RegExp(r'OS(\d+\.\d+\.\d+)').firstMatch(incProp);
        if (match != null) {
          romVersion = '${match.group(1)} ($incProp)';
        } else {
          romVersion = incProp;
        }
      } else {
        romVersion = baseName;
      }
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
    final socDecimal = stats['soc_decimal']?.trim();

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

    final int? cycleCount = int.tryParse(stats['cycle_count'] ?? '');
    double? hardwareSoh;
    final rawSoh = stats['soh'];
    if (rawSoh != null && rawSoh.isNotEmpty && rawSoh != '0') {
      final sohVal = double.tryParse(rawSoh);
      if (sohVal != null && sohVal > 0 && sohVal <= 100) {
        hardwareSoh = sohVal / 100.0;
      }
    }

    double batteryHealth = 0.0;
    if (hardwareSoh != null) {
      batteryHealth = hardwareSoh;
    } else if (designCapacityMAh > 0 && capacityMAh > 0) {
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

    final protocolInfo = ChargingProtocolInfo.analyze(
      isCharging: isCharging,
      wattageW: wattageW,
      voltageV: voltageV,
      currentMA: currentMA,
      rawStats: stats,
    );

    return BatteryStats(
      rawStats: stats,
      model: model,
      androidVer: androidVer,
      rom: rom,
      status: status,
      percentage: percentage,
      socDecimal: socDecimal,
      voltageV: voltageV,
      currentA: currentA,
      currentMA: currentMA,
      wattageW: wattageW,
      capacityMAh: capacityMAh,
      designCapacityMAh: designCapacityMAh,
      batteryHealth: batteryHealth,
      cycleCount: cycleCount,
      hardwareSoh: hardwareSoh,
      cpuTempC: cpuTempC,
      battTempC: battTempC,
      timeRemainingStr: timeRemainingStr,
      isCharging: isCharging,
      isFull: isFull,
      protocolInfo: protocolInfo,
    );
  }
}

/// Shown only on first launch (before language_selected pref is set).
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
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
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Icon(
                  Icons.language_rounded,
                  size: 80,
                  color: Color(0xFF38BDF8),
                ),
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
                  'Select Language / Dil Seçin / Seleccionar idioma',
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
                const SizedBox(height: 16),
                _buildLangOption(
                  label: 'Español',
                  subtitle: 'Spanish',
                  flag: '🇪🇸',
                  value: 'es',
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
                    _selected == 'en' ? 'Continue' : (_selected == 'es' ? 'Continuar' : 'Devam Et'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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
              ? const Color(0xFF38BDF8).withValues(alpha: 0.15)
              : const Color(0xFF1E293B).withValues(alpha: 0.7),
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
            Expanded(
              child: Column(
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
            ),
            const SizedBox(width: 8),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF38BDF8),
                size: 24,
              ),
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
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildOptionButton(
                        context: context,
                        label: tr('turkish'),
                        isSelected: locale == 'tr',
                        onTap: () => SettingsManager.setLanguage('tr'),
                      ),
                      const SizedBox(width: 8),
                      _buildOptionButton(
                        context: context,
                        label: tr('english'),
                        isSelected: locale == 'en',
                        onTap: () => SettingsManager.setLanguage('en'),
                      ),
                      const SizedBox(width: 8),
                      _buildOptionButton(
                        context: context,
                        label: tr('spanish'),
                        isSelected: locale == 'es',
                        onTap: () => SettingsManager.setLanguage('es'),
                      ),
                    ],
                  ),
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
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  ),
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
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF38BDF8).withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF38BDF8) : Colors.white10,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: isSelected ? const Color(0xFF38BDF8) : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
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
                  icon: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white70,
                    size: 28,
                  ),
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
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                icon: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white70,
                  size: 28,
                ),
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
                          const CircularProgressIndicator(
                            color: Color(0xFF38BDF8),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            tr('checking_root'),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
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
                              shadowColor: const Color(
                                0xFF38BDF8,
                              ).withValues(alpha: 0.5),
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
    with TickerProviderStateMixin, WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _updateStats();
    _startStatsTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopStatsTimer();
    _pulseController.dispose();
    _maController.dispose();
    super.dispose();
  }

  void _startStatsTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _updateStats());
  }

  void _stopStatsTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _updateStats();
      _startStatsTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopStatsTimer();
    }
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
    final model = (stats.model == 'Bilinmiyor' || stats.model == 'Unknown')
        ? tr('unknown')
        : stats.model;
    final androidVer =
        (stats.androidVer == 'Bilinmiyor' || stats.androidVer == 'Unknown')
        ? tr('unknown')
        : stats.androidVer;
    final rom = (stats.rom == 'Bilinmiyor' || stats.rom == 'Unknown')
        ? tr('unknown')
        : stats.rom;
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
                              color: Colors.greenAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.isRooted
                                  ? tr('root_active')
                                  : tr('rootless_active'),
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
                            icon: const Icon(
                              Icons.settings_rounded,
                              color: Colors.white70,
                              size: 28,
                            ),
                            onPressed: () => showSettingsBottomSheet(context),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(
                              0xFF38BDF8,
                            ).withValues(alpha: 0.2),
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
                                  ? const Color(0xFF38BDF8).withValues(alpha: 0.4)
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
                                  isCharging
                                      ? tr('charge_watt')
                                      : tr('discharge_watt'),
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

                  const SizedBox(height: 28),

                  // Charging Protocol & PD vs QC Gauge
                  _buildChargingProtocolGauge(context, stats),

                  const SizedBox(height: 28),

                  // Info Grid (Dynamic Sizing)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.electric_meter_rounded,
                            title: isCharging
                                ? tr('current_charge')
                                : tr('current_discharge'),
                            value: isCharging
                                ? '$currentMA mA'
                                : '-$currentMA mA',
                            color: const Color(0xFFF43F5E),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.electrical_services_rounded,
                            title: tr('voltage'),
                            value: '${voltageV.toStringAsFixed(2)} V',
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.battery_charging_full_rounded,
                            title: tr('capacity'),
                            value: capacityMAh > 0
                                ? '$capacityMAh mAh'
                                : tr('unknown'),
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.percent_rounded,
                            title: tr('charge_percentage'),
                            value: (stats.socDecimal != null && stats.socDecimal!.isNotEmpty && stats.socDecimal != '0')
                                ? '%$percentage.${stats.socDecimal!.padLeft(2, '0')}'
                                : '%$percentage',
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Battery Temp Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF97316).withValues(alpha: 0.1),
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
                      color: const Color(0xFF1E293B).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
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
                        color: const Color(0xFF1E293B).withValues(alpha: 0.7),
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
                                  ).withValues(alpha: 0.1),
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
                                      '%${(batteryHealth * 100).toStringAsFixed(1)} ($capacityMAh / $designCapacityMAh mAh)${stats.cycleCount != null && stats.cycleCount! > 0 ? ' • ${tr('cycles_count', [stats.cycleCount.toString()])}' : ''}',
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
                      color: const Color(0xFF1E293B).withValues(alpha: 0.7),
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
        color: const Color(0xFF1E293B).withValues(alpha: 0.7),
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
              Expanded(
                child: Text(
                  tr('charge_limiter'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
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
      backgroundColor: const Color(0xFF38BDF8).withValues(alpha: 0.2),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: () {
        // Pil voltajı genelde ortalama 4.0V civarındadır (Watt = Amper * Voltaj)
        final mA = ((watt / 4.0) * 1000).round();
        _maController.text = mA.toString();
        RootService.setChargeLimit(mA);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tr('limit_watt_set_msg', [watt.toString(), mA.toString()]),
            ),
          ),
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
        color: const Color(0xFF1E293B).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          flex: 3,
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

  Widget _buildChargingProtocolGauge(BuildContext context, BatteryStats stats) {
    final info = stats.protocolInfo;
    final isCharging = stats.isCharging;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCharging
              ? info.accentColor.withValues(alpha: 0.3)
              : Colors.white10,
          width: isCharging ? 1.5 : 1.0,
        ),
        boxShadow: isCharging
            ? [
                BoxShadow(
                  color: info.accentColor.withValues(alpha: 0.12),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title, Beta Badge, and Info Button (Dynamic layout, never truncates)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: info.accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  info.icon,
                  color: info.accentColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Text(
                      tr('charging_protocol'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.6),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        tr('beta'),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFF59E0B),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white54,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: tr('pd_vs_qc_title'),
                onPressed: () => _showProtocolInfoSheet(context, stats),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Sub-Header Badges: Hardware Verification & Connection Status (Wrap prevents overflow/truncation)
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 6,
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: info.isVerifiedHardware
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: info.isVerifiedHardware
                        ? const Color(0xFF10B981).withValues(alpha: 0.4)
                        : const Color(0xFFF59E0B).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      info.isVerifiedHardware
                          ? Icons.verified_rounded
                          : Icons.insights_rounded,
                      size: 12,
                      color: info.isVerifiedHardware
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      info.isVerifiedHardware
                          ? tr('pmic_verified')
                          : tr('estimated_mode'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: info.isVerifiedHardware
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isCharging
                      ? info.accentColor.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCharging
                        ? info.accentColor.withValues(alpha: 0.4)
                        : Colors.white24,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCharging ? info.accentColor : Colors.white38,
                        boxShadow: isCharging
                            ? [
                                BoxShadow(
                                  color: info.accentColor,
                                  blurRadius: 5,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isCharging
                          ? tr('active_connection')
                          : tr('inactive_connection'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isCharging ? Colors.white : Colors.white54,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Main Hero Protocol Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isCharging
                    ? [
                        info.accentColor.withValues(alpha: 0.18),
                        const Color(0xFF0F172A).withValues(alpha: 0.6),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.black12,
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCharging
                    ? info.accentColor.withValues(alpha: 0.3)
                    : Colors.white10,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        info.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    if (info.code.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white24, width: 0.8),
                        ),
                        child: Text(
                          info.code,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: info.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  info.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // PD mi QC mi? Visual Ladder Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr('pd_vs_qc_title'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60,
                ),
              ),
              if (info.isPd)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tr('ladder_pd_active'),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                )
              else if (info.isQc)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tr('ladder_qc_active'),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF97316),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // 4-Step Visual Ladder Segments (IntrinsicHeight ensures uniform dynamic expansion)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildLadderChip(
                    stepNumber: 1,
                    label: tr('step_standard_5v'),
                    isActive: info.activeLadderStep == 1,
                    activeColor: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildLadderChip(
                    stepNumber: 2,
                    label: tr('step_qualcomm_qc'),
                    isActive: info.activeLadderStep == 2,
                    activeColor: const Color(0xFFF97316),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildLadderChip(
                    stepNumber: 3,
                    label: tr('step_usb_pd'),
                    isActive: info.activeLadderStep == 3,
                    activeColor: const Color(0xFF38BDF8),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildLadderChip(
                    stepNumber: 4,
                    label: tr('step_pd_pps_turbo'),
                    isActive: info.activeLadderStep == 4,
                    activeColor: const Color(0xFFA855F7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Speed Level Meter Bar (Wrap prevents overflow between title & value)
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 4,
            spacing: 8,
            children: [
              Text(
                tr('speed_level'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60,
                ),
              ),
              Text(
                isCharging
                    ? _getSpeedLevelLabel(info.speedLevel, stats.wattageW)
                    : tr('not_charging'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isCharging ? info.accentColor : Colors.white54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 5-Segment Progress Bar
          Row(
            children: [
              Expanded(
                child: _buildSpeedSegment(
                  index: 1,
                  currentIndex: _getSpeedIndex(info.speedLevel),
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildSpeedSegment(
                  index: 2,
                  currentIndex: _getSpeedIndex(info.speedLevel),
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildSpeedSegment(
                  index: 3,
                  currentIndex: _getSpeedIndex(info.speedLevel),
                  color: const Color(0xFF38BDF8),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildSpeedSegment(
                  index: 4,
                  currentIndex: _getSpeedIndex(info.speedLevel),
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildSpeedSegment(
                  index: 5,
                  currentIndex: _getSpeedIndex(info.speedLevel),
                  color: const Color(0xFFF43F5E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Technical Parameter Grid (2x2) (IntrinsicHeight rows dynamically expand for full text)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildMicroParam(
                    title: tr('pd_status'),
                    value: info.pdStatusText,
                    color: const Color(0xFF38BDF8),
                    icon: Icons.electrical_services_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMicroParam(
                    title: tr('qc_status'),
                    value: info.qcStatusText,
                    color: const Color(0xFFF97316),
                    icon: Icons.speed_rounded,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildMicroParam(
                    title: tr('pmic_register'),
                    value: info.pmicRegisterText,
                    color: const Color(0xFF10B981),
                    icon: Icons.memory_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMicroParam(
                    title: tr('line_voltage'),
                    value: info.inputVoltageStr,
                    color: const Color(0xFFF59E0B),
                    icon: Icons.power_input_rounded,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Beta Warning Note
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFF59E0B),
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tr('protocol_beta_warning_short'),
                    style: const TextStyle(
                      color: Color(0xFFFDE68A),
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLadderChip({
    required int stepNumber,
    required String label,
    required bool isActive,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? activeColor.withValues(alpha: 0.22)
            : const Color(0xFF0F172A).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? activeColor : Colors.white12,
          width: isActive ? 1.5 : 1.0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.35),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: isActive ? activeColor : Colors.white30,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.white : Colors.white38,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedSegment({
    required int index,
    required int currentIndex,
    required Color color,
  }) {
    final bool isFilled = index <= currentIndex;
    final bool isCurrent = index == currentIndex;

    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: isFilled ? color : Colors.white10,
        borderRadius: BorderRadius.circular(3),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: color,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }

  int _getSpeedIndex(ChargingSpeedLevel level) {
    switch (level) {
      case ChargingSpeedLevel.slow:
        return 1;
      case ChargingSpeedLevel.normal:
        return 2;
      case ChargingSpeedLevel.fast:
        return 3;
      case ChargingSpeedLevel.superFast:
        return 4;
      case ChargingSpeedLevel.ultraFast:
        return 5;
      case ChargingSpeedLevel.none:
        return 0;
    }
  }

  String _getSpeedLevelLabel(ChargingSpeedLevel level, double watt) {
    final wattStr = '${watt.toStringAsFixed(1)}W';
    switch (level) {
      case ChargingSpeedLevel.slow:
        return '${tr('speed_slow')} ($wattStr)';
      case ChargingSpeedLevel.normal:
        return '${tr('speed_normal')} ($wattStr)';
      case ChargingSpeedLevel.fast:
        return '${tr('speed_fast')} ($wattStr)';
      case ChargingSpeedLevel.superFast:
        return '${tr('speed_super')} ($wattStr)';
      case ChargingSpeedLevel.ultraFast:
        return '${tr('speed_ultra')} ($wattStr)';
      case ChargingSpeedLevel.none:
        return tr('not_charging');
    }
  }

  Widget _buildMicroParam({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProtocolInfoSheet(BuildContext context, BatteryStats stats) {
    final info = stats.protocolInfo;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: Colors.white12)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFF38BDF8),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr('info_sheet_title'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            tr('info_sheet_subtitle'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white60),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Beta Warning Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr('beta_warning_title'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF59E0B),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tr('protocol_beta_warning'),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Card 1: What is PD?
                _buildInfoSection(
                  icon: Icons.bolt_rounded,
                  color: const Color(0xFF38BDF8),
                  title: tr('what_is_pd_title'),
                  desc: tr('what_is_pd_desc'),
                ),
                const SizedBox(height: 12),

                // Card 2: What is QC?
                _buildInfoSection(
                  icon: Icons.offline_bolt_rounded,
                  color: const Color(0xFFF97316),
                  title: tr('what_is_qc_title'),
                  desc: tr('what_is_qc_desc'),
                ),
                const SizedBox(height: 12),

                // Card 3: How do we detect it?
                _buildInfoSection(
                  icon: Icons.developer_board_rounded,
                  color: const Color(0xFF10B981),
                  title: tr('how_we_detect_title'),
                  desc: tr('how_we_detect_desc'),
                ),

                if (info.debugRegisters.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    tr('protocol_registers'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: info.debugRegisters.entries
                          .where((e) => e.value.isNotEmpty)
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '${e.key}: ${e.value}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: Color(0xFF38BDF8),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      tr('close'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
