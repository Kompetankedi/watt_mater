<div align="center">
  <img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/flutter-logo.svg?sanitize=true" alt="Flutter" width="90"/>
  <h1>⚡ Watt Meter ⚡</h1>
  <p>
    <b>Real-time Battery Power Monitor, Charging Protocol Detection (PD vs QC), and Current Limiter for Android.</b><br>
    <b>Android için Gerçek Zamanlı Güç Monitörü, Şarj Protokolü Tespiti (PD vs QC) ve Akım Sınırlandırıcı.</b>
  </p>

  <p>
    <a href="#english-"><strong>English 🇬🇧</strong></a> ·
    <a href="#türkçe-"><strong>Türkçe 🇹🇷</strong></a>
  </p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter badge" />
    <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android badge" />
    <img src="https://img.shields.io/badge/Open_Source-❤-ff69b4?style=for-the-badge" alt="Open Source badge"/>
    <img src="https://img.shields.io/badge/Root-Magisk%20%7C%20KernelSU%20%7C%20APatch-red?style=for-the-badge" alt="Root badge" />
    <img src="https://img.shields.io/badge/Dual_Mode-Rooted%20%26%20Rootless-success?style=for-the-badge" alt="Dual Mode badge" />
  </p>
</div>

---

# English 🇬🇧

**Watt Meter** is a powerful, fully open-source Flutter application engineered for Android. It monitors battery metrics, power delivery protocols, and hardware registers in real time. Designed with a sleek cyberpunk dark aesthetic, it works in both **Rooted** (full hardware PMIC control) and **Rootless** (standard battery metrics) modes.

---

## 🚀 Key Features

### 1. ⚡ Charging Protocol Detection (PD vs QC) [BETA]
Ever wondered whether your phone is negotiating **USB Power Delivery (PD)** or **Qualcomm Quick Charge (QC)**? Watt Meter checks kernel hardware registers directly:
* **Protocol Classification:**
  * **USB Power Delivery (PD):** Type-C CC pin digital handshake (5V, 9V, 12V, 15V, 20V).
  * **USB-PD 3.0 PPS:** Programmable Power Supply with 20mV dynamic voltage stepping.
  * **Qualcomm Quick Charge (QC):** QC 2.0 (fixed 9V/12V), QC 3.0 (200mV increments), QC 3+, and QC 4/4+ (PD-PPS hybrid).
  * **OEM Fast Charging:** Xiaomi Mi Turbo Charge / HyperCharge, SuperVOOC / Warp / Dart, Samsung Adaptive Fast Charging (AFC), Dedicated Charging Port (DCP 5V), and PC Data Port (SDP/CDP).
* **4-Step Visual Ladder:** Instantly visualizes whether charging is at `Standard 5V`, `Qualcomm QC`, `USB-PD`, or `PD-PPS / Turbo`.
* **5-Segment Speed Gauge:** Categorizes charging speed into *Slow, Normal, Fast, Super Fast,* and *Ultra/Turbo*.
* **Live Hardware PMIC Matrix:** Displays real-time PD status, QC status, PMIC sysfs register value, and input line voltage.
* **In-App Protocol Guide:** Includes a built-in guide explaining the differences between USB-PD and Qualcomm QC.

### 2. 🛡️ Charging Speed Limiter (Rooted) [BETA]
Protect battery health and reduce charging heat:
* **Custom mA Limits:** Set maximum charge current directly to the kernel (e.g. 1500 mA, 2000 mA).
* **Quick Watt Presets:** 1-tap presets from **5W** up to **120W**, plus a **Reset** button to restore default charging speeds.
* Writes directly to `/sys/class/power_supply/battery/constant_charge_current_max` and compatible vendor sysfs nodes.

### 3. 📊 Real-time Power & Discharge Analytics
* **Live Power Metric (Watts):** Real-time calculated wattage ($P = V \times I$) with a smooth breathing pulse animation.
* **Accurate Drain Measurements:** When unplugged, displays negative current ($-mA$) and discharge wattage to measure screen-on/idle consumption.
* **Precise Voltage & Amperage:** Millivolt and milliamp readings refreshed in real time.

### 4. 🔋 Battery Health & Estimation
* **Health Percentage:** Reads `charge_full` vs `charge_full_design` to compute remaining battery capacity.
* **Smart Time-to-Full:** Accurate remaining time calculations until 100% full charge.
* **Thermal Sensor:** Live battery temperature monitoring in °C.

### 5. 📱 Dual Operation Modes
* **Rooted Mode:** Requires Magisk, KernelSU, or APatch. Unlocks PMIC register reads and charge current limits.
* **Rootless Mode:** Works out of the box on non-rooted phones using Android BatteryManager APIs and permission-free kernel nodes.

### 6. 🌐 Dual-Language Support
* Fully localized in **English** and **Turkish** with instant switching from the Settings sheet.

---

## 🛠️ Sysfs Hardware Nodes Inspected

```
/sys/class/power_supply/usb/real_type
/sys/class/power_supply/usb/pd_active
/sys/class/power_supply/usb/quick_charge_type
/sys/class/power_supply/usb/hvdcp3_type
/sys/class/power_supply/usb/typec_mode
/sys/class/typec/port0/pwr_opmode
/sys/class/power_supply/battery/charger_type
/sys/class/power_supply/battery/turbo_mode
/sys/class/power_supply/battery/constant_charge_current_max
```

---

## ⚙️ Requirements

* **Operating System:** Android 5.0 (API 21) or higher.
* **Root Solution (Optional for full features):** Magisk, KernelSU, or APatch.
* **Flutter SDK:** Flutter 3.19+ (Dart 3.3+).

---

## 🔨 Installation & Build

### 1. Clone the Repository
```bash
git clone https://github.com/Kompetankedi/watt_mater.git
cd watt_mater
```

### 2. Fetch Dependencies
```bash
flutter pub get
```

### 3. Run Locally
```bash
flutter run
```

### 4. Build Optimized Release APKs (Split per ABI)
```bash
flutter build apk --split-per-abi
```
Generated APKs will be located in:
`build/app/outputs/flutter-apk/`
* `app-arm64-v8a-release.apk` (modern 64-bit devices)
* `app-armeabi-v7a-release.apk` (legacy 32-bit devices)
* `app-x86_64-release.apk` (emulators / x86_64)

---

## 📜 License

This project is licensed under the **MIT License**. Feel free to use, modify, and distribute.

---

# Türkçe 🇹🇷

**Watt Meter**, Android cihazlar için geliştirilmiş, donanım düzeyinde gerçek zamanlı pil değerlerini, şarj protokollerini ve güç tüketimini izleyen açık kaynaklı bir Flutter uygulamasıdır. Modern siberpunk karanlık teması ile hem **Rootlu** (tam donanım ve PMIC kontrolü) hem de **Rootsuz** (temel batarya verileri) modda çalışır.

---

## 🚀 Öne Çıkan Özellikler

### 1. ⚡ Şarj Protokolü Tespiti (PD mi QC mi?) [BETA]
Telefonunuzun **USB Power Delivery (PD)** ile mi yoksa **Qualcomm Quick Charge (QC)** ile mi şarj olduğunu anlık olarak kernel seviyesinde donanım kayıtlarından tespit eder:
* **Protokol Sınıflandırması:**
  * **USB Power Delivery (PD):** Type-C CC pinleri üzerinden dijital el sıkışma (5V, 9V, 12V, 15V, 20V).
  * **USB-PD 3.0 PPS:** 20mV adımlı dinamik voltaj regülasyonu.
  * **Qualcomm Quick Charge (QC):** QC 2.0 (9V/12V sabit), QC 3.0 (200mV kademeli), QC 3+ ve QC 4/4+ (PD-PPS hibrit).
  * **Üretici Hızlı Şarjları:** Xiaomi Mi Turbo Charge / HyperCharge, SuperVOOC / Warp / Dart, Samsung Adaptive Fast Charging (AFC), Standart Adaptör (DCP 5V) ve Bilgisayar Veri Portu (SDP/CDP).
* **4 Kademeli Görsel Merdiven:** Şarjın `Standart 5V`, `Qualcomm QC`, `USB-PD` veya `PD-PPS / Turbo` kademelerinden hangisinde olduğunu anlık ışıklandırır.
* **5 Segmentli Hız Göstergesi:** Şarj gücünü *Yavaş, Normal, Hızlı, Süper Hızlı* ve *Ultra/Turbo* seviyelerine ayırır.
* **Canlı Donanım PMIC Tablosu:** PD durumu, QC durumu, PMIC sysfs ham kaydı ve hat voltajını eşzamanlı gösterir.
* **Uygulama İçi Protokol Rehberi:** PD ile QC arasındaki farkları ve uygulamanın donanımı nasıl okuduğunu anlatan detaylı bilgilendirme paneli.

### 2. 🛡️ Şarj Hızı Sınırlandırıcı (Rootlu) [BETA]
Pil ömrünü korumak ve şarj sırasındaki aşırı ısınmayı engellemek için:
* **Manuel mA Sınırı:** İstenen akım sınırını doğrudan kernele uygular (Örn: 1500 mA, 2000 mA).
* **Hızlı Watt Butonları:** **5W**'tan **120W**'a kadar tek dokunuşla hazır limitler ve varsayılan hıza dönmek için **Sıfırla** butonu.
* Doğrudan `/sys/class/power_supply/battery/constant_charge_current_max` ve uyumlu üretici düğümlerine yazar.

### 3. 📊 Gerçek Zamanlı Güç ve Deşarj Analizi
* **Anlık Güç Değeri (Watt):** $P = V \times I$ formülüyle anlık hesaplanan ve şarj durumuna göre nefes alıp veren dinamik halka gösterge.
* **Hassas Deşarj Ölçümü:** Şarjdan çekildiğinde negatif akım ($-mA$) ve "Deşarj Watt" göstererek ekran açık/kapalı tüketimi net ölçer.
* **Hassas Voltaj ve Akım:** Milivolt ve miliamper seviyesinde kesintisiz canlı akış.

### 4. 🔋 Pil Sağlığı ve Tahmin
* **Pil Sağlığı / Ömrü:** Fabrika tasarım kapasitesi (`charge_full_design`) ile güncel dolum kapasitesini (`charge_full`) kıyaslayarak gerçek pil sağlığını hesaplar.
* **Akıllı Tam Dolum Süresi:** Bataryanın %100 dolmasına kalan süreyi dinamik olarak hesaplar.
* **Termal Sensör:** Canlı pil sıcaklığı (°C).

### 5. 📱 Çift Çalışma Modu (Rootlu & Rootsuz)
* **Rootlu Mod:** Magisk, KernelSU veya APatch yetkisiyle tam PMIC donanım okuması ve şarj sınırlama yeteneği.
* **Rootsuz Mod:** Root yetkisi olmayan cihazlarda Android BatteryManager API'leri ve izin verilen sysfs yollarıyla temel izleme.

### 6. 🌐 Çift Dil Desteği
* **Türkçe** ve **İngilizce** dilleri arasında Ayarlar menüsünden anında geçiş imkanı.

---

## 🛠️ Okunan Kernel Donanım Düğümleri

```
/sys/class/power_supply/usb/real_type
/sys/class/power_supply/usb/pd_active
/sys/class/power_supply/usb/quick_charge_type
/sys/class/power_supply/usb/hvdcp3_type
/sys/class/power_supply/usb/typec_mode
/sys/class/typec/port0/pwr_opmode
/sys/class/power_supply/battery/charger_type
/sys/class/power_supply/battery/turbo_mode
/sys/class/power_supply/battery/constant_charge_current_max
```

---

## ⚙️ Gereksinimler

* **İşletim Sistemi:** Android 5.0 (Lollipop / API 21) veya üzeri.
* **Root Yetkisi (Gelişmiş özellikler için opsiyonel):** Magisk, KernelSU veya APatch.
* **Flutter SDK:** Flutter 3.19+ (Dart 3.3+).

---

## 🔨 Kurulum ve Derleme

### 1. Repoyu Klonlayın
```bash
git clone https://github.com/Kompetankedi/watt_mater.git
cd watt_mater
```

### 2. Bağımlılıkları İndirin
```bash
flutter pub get
```

### 3. Cihazda Çalıştırın
```bash
flutter run
```

### 4. Optimize Release APK Üretimi (Mimarilere Göre Ayrılmış)
```bash
flutter build apk --split-per-abi
```
Oluşturulan APK dosyaları şu dizinde yer alır:
`build/app/outputs/flutter-apk/`
* `app-arm64-v8a-release.apk` (modern 64-bit cihazlar için)
* `app-armeabi-v7a-release.apk` (eski 32-bit cihazlar için)
* `app-x86_64-release.apk` (emülatörler ve x86_64 için)

---

## 📜 Lisans

Bu proje **MIT Lisansı** ile lisanslanmıştır. Özgürce inceleyebilir, değiştirebilir ve projelerinizde kullanabilirsiniz.
