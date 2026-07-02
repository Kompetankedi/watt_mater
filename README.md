<div align="center">
  <img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/flutter-logo.svg?sanitize=true" alt="Flutter" width="100"/>
  <h1>⚡ Watt Mater ⚡</h1>
  <p>
    <b>The ultimate root-required real-time Android battery stats monitor.</b><br>
    <b>Android cihazlar için root gerektiren, anlık batarya istatistikleri okuma aracı.</b>
  </p>

  <p>
    <a href="#english-"><strong>English 🇬🇧</strong></a> ·
    <a href="#türkçe-"><strong>Türkçe 🇹🇷</strong></a>
  </p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter badge" />
    <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android badge" />
    <img src="https://img.shields.io/badge/Open_Source-❤-ff69b4?style=for-the-badge" alt="Open Source badge"/>
    <img src="https://img.shields.io/badge/Root_Required-Magisk%20%7C%20KernelSU-red?style=for-the-badge" alt="Root Only badge" />
  </p>
</div>

---

# English 🇬🇧

**Watt Mater** is a fully open-source Flutter application that reads real-time battery data (voltage, amperage, wattage) directly from the hardware sys-fs of your Android device and presents it with a modern, sleek interface. It requires Root access (Magisk, KernelSU, SuperSU, etc.) to fetch this data.

## 🚀 Features

- **Real-time Power Analytics:** Live display of Voltage (V), Current (mA), and Power (Watt) metrics. Accurately calculates charge speeds and discharge rates.
- **Accurate Discharge Stats:** When unplugged, clearly shows negative (-) current and discharge wattage to measure your battery drain precisely.
- **Hardware & System Info:** Detects device model and custom ROM version (e.g., LineageOS, crDroid, HyperOS, etc.).
- **Battery Health & Estimations:** Reads `charge_full` and `charge_full_design` natively to display battery degradation and health percentage. Provides smart estimations for time remaining to full charge.
- **Automated Root Management:** Checks for root privileges on startup. If not present, prompts the user seamlessly.
- **Modern & Dynamic UI:** Beautiful, liquid-like gradient pulse animations when charging, optimized dark mode aesthetics.

## ⚙️ Requirements

- Android 5.0+ Device.
- **Root Permission** (Magisk, KernelSU, etc.). This app requires kernel-level `/sys/class/power_supply` read access.
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (if you want to build it yourself).

## 🔨 Installation & Build

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/watt_mater.git
   cd watt_mater
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run on your **Rooted** Android device with USB Debugging enabled:
   ```bash
   flutter run
   ```

## 🤝 Contributing

We love the open-source community! Contributions, bug reports, and pull requests are always welcome. Feel free to fork the repository and submit your changes. 

## 📜 License

This project is completely open source under the **MIT License**. Feel free to use, modify, and distribute.

---

# Türkçe 🇹🇷

**Watt Mater**, tamamen açık kaynak kodlu olan ve Android cihazınızın anlık olarak pil değerlerini (gerilim, akım, güç/watt) donanımdan okuyarak modern bir arayüzle kullanıcıya sunan bir araçtır. `/sys/class/power_supply` dosya yolundaki değerleri okuyabilmesi için Root erişimine (Magisk, KernelSU, vb.) ihtiyaç duyar.

## 🚀 Özellikler

- **Gerçek Zamanlı Güç Verisi:** Anlık Voltaj (V), Akım (mA) ve Güç Tüketimi (Watt) bilgilerini yansıtır.
- **Gelişmiş Deşarj Analizi:** Cihaz şarjdan çıkarıldığında tam olarak ne kadar tüketim yapıldığını negatif (-) akım değerleri ve "Deşarj Watt" şeklinde ölçümleyebilir.
- **Detaylı Pil Durumu:** Pil sağlığı yüzdesi, tasarım kapasitesi ve gerçek dolum kapasitesi okumaları. Ayrıca "%100 Tam dolu" ve şarj tahmini hesaplamaları.
- **Donanım & Sistem Bilgisi:** Cihaz modelini ve kurulu Custom ROM sürümünü (LineageOS, crDroid, HyperOS vb.) otomatik saptar.
- **Otomatik Root Yönetimi:** Uygulama açılışında root yetkisini denetler ve modern bir ekranla doğrudan istek atar.
- **Dinamik UI:** Şarj esnasında nefes alan modern gradient renkler ve şık kurgulanmış siyah (dark) tema.

## ⚙️ Gereksinimler

- Android 5.0 ve üzeri cihaz.
- **Root İzni** (Magisk, KernelSU vb.).
- Uygulamayı kendiniz derlemek isterseniz bilgisayarınıza kurulu [Flutter SDK](https://flutter.dev/docs/get-started/install).

## 🔨 Kurulum ve Derleme

1. Bu projeyi bilgisayarınıza klonlayın:
   ```bash
   git clone https://github.com/KULLANICI_ADINIZ/watt_mater.git
   cd watt_mater
   ```
2. Gerekli Flutter paketlerini indirin:
   ```bash
   flutter pub get
   ```
3. Geliştirici seçenekleri ve USB Hata ayıklaması açık **Rootlu** bir Android cihaza uygulamayı yükleyin:
   ```bash
   flutter run
   ```

## 🤝 Katkıda Bulunma (Contributing)

Bu proje herkesin öğrenmesi ve geliştirmesi için açık kaynaklıdır! Sorun bildirimlerine (Issue) ve PR gönderimlerine sonuna kadar açığız. Kendine güveniyorsan repoyu çatallayıp (fork) bize katılabilirsin.

## 📜 Lisans

Bu proje **MIT Lisansı** ile tamamen açık kaynaktır. Kodu inceleyebilir, değiştirebilir ve özgürce kendi projelerinizde kullanabilirsiniz.
