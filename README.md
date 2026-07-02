# Watt Mater ⚡

**Watt Mater**, root (Magisk/KernelSU vb.) erişimi gerektiren ve Android cihazınızın anlık olarak pil değerlerini (gerilim, akım, wattaj) doğrudan donanımdan çekip modern bir arayüzle kullanıcıya sunan bir Flutter uygulamasıdır.

## 🚀 Özellikler

- **Gerçek Zamanlı Güç Verisi:** Anlık Voltaj (V), Akım (mA) ve Güç tüketimi/şarj gücü (Watt) hesaplamaları.
- **Detaylı Pil Durumu:** Pil kapasitesi (mAh), şarj yüzdesi ve şarj dolum veya bitim sürelerine ait tahmini hesaplamalar.
- **Donanım & Sistem Bilgisi:** Cihaz modeli ve yüklü olan ROM (Build ID) bilgisi.
- **Otomatik Root Yönetimi:** Uygulama açılışında root kontrolü ve yetki isteği; yetki yoksa kullanıcıyı bilgilendiren uyarı ekranı.
- **Modern Arayüz (UI):** Şarj esnasında etkileşimli çalışan animasyonlar, neon pastel vurgulara sahip modern ve koyu (dark) tema.

## 🛠 Teknik Altyapı

- **Flutter & Dart:** Kullanıcı arayüzü ve state yönetimi.
- **Native Android Sistem Çağrıları:** `su` kabuğu üzerinden `/sys/class/power_supply/battery/` ve `getprop` yardımıyla gerçek donanım verilerinin okunması.

## ⚙️ Gereksinimler

- Android 5.0 ve üzeri cihaz.
- **Root İzni** (Örn: Magisk, KernelSU veya SuperSU).
- Kendi cihazınızda derlemek istiyorsanız [Flutter SDK](https://flutter.dev/docs/get-started/install).

## 🚀 Kurulum ve Derleme

1. Bu projeyi bilgisayarınıza klonlayın:
   ```bash
   git clone https://github.com/KULLANICI_ADINIZ/watt_mater.git
   cd watt_mater
   ```

2. Flutter paketlerini indirin:
   ```bash
   flutter pub get
   ```

3. Geliştirici seçenekleri ve USB Hata ayıklaması açık, **Rootlu** bir Android cihaza uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

> ⚠️ **Uyarı:** Uygulamanın doğrudan donanım dosyalarından veri çekmesi nedeniyle, sisteminizde root izninin uygulamaya kalıcı olarak veya istendiği esnada verildiğinden emin olun. Root olmayan bir cihazda uygulama ana ekrana geçiş yapamaz.

## 📝 Katkıda Bulunma (Contributing)

Geliştirmelere, hata çözümlerine (Issue & PR) her zaman açığız! Katkıda bulunmak için repoyu forplayabilir ve değişikliklerinizi bize gönderebilirsiniz.

## 📜 Lisans

Bu proje bir başlangıç noktası olarak tasarlanmıştır ve herkes dilediği gibi düzenleyebilir / geliştirebilir. 
