# 🚀 Skincare & Rituals iOS Uygulaması - Kurulum Rehberi

Bu rehber, Skincare & Rituals iOS uygulamasını Xcode'da başarıyla açıp çalıştırmanız için adım adım talimatları içerir.

## 📋 Gereksinimler

- **macOS**: Son sürüm (Ventura veya üzeri)
- **Xcode**: 15.0 veya üzeri
- **iOS Simulator**: iPhone 16 veya üzeri
- **Git**: Yüklü olmalı

## 🔧 Kurulum Adımları

### 1. Projeyi İndirin

```bash
# Terminal'i açın ve projeyi klonlayın
git clone https://github.com/beyzatunca/SkincareAndRituals.git

# Proje dizinine gidin
cd SkincareAndRituals
```

### 2. Xcode'da Projeyi Açın

#### Yöntem 1: Terminal ile
```bash
# Xcode'da projeyi açın
open SkincareAndRituals.xcodeproj
```

#### Yöntem 2: Finder ile
1. Finder'da `SkincareAndRituals` klasörüne gidin
2. `SkincareAndRituals.xcodeproj` dosyasına çift tıklayın

### 3. Simülatör Seçimi

1. Xcode açıldıktan sonra, üst kısımda simülatör seçin:
   - **iPhone 16** (önerilen)
   - **iPhone 16 Pro**
   - **iPhone 15**
   - Veya başka bir iPhone simülatörü

### 4. Projeyi Build Edin

#### Yöntem 1: Xcode UI ile
1. **Product** → **Build** (⌘+B)
2. Veya **Product** → **Run** (⌘+R)

#### Yöntem 2: Terminal ile
```bash
# Proje dizininde olduğunuzdan emin olun
cd SkincareAndRituals

# Build edin
xcodebuild -project SkincareAndRituals.xcodeproj -scheme SkincareAndRituals -destination 'platform=iOS Simulator,name=iPhone 16' build
```

### 5. Uygulamayı Çalıştırın

#### Yöntem 1: Xcode UI ile
1. **Product** → **Run** (⌘+R)
2. Simülatör otomatik olarak açılacak ve uygulama başlayacak

#### Yöntem 2: Terminal ile
```bash
# Simülatörü başlatın (eğer kapalıysa)
xcrun simctl boot "iPhone 16"

# Uygulamayı yükleyin
xcrun simctl install booted DerivedData/Build/Products/Debug-iphonesimulator/SkincareAndRituals.app

# Uygulamayı başlatın
xcrun simctl launch booted com.beyzatunca.SkincareAndRituals
```

## 🛠️ Sorun Giderme

### Hata 1: "Build input file cannot be found"
**Çözüm**: Proje dosyası eksik. Şu adımları takip edin:
1. Terminal'de proje dizinine gidin
2. `git status` ile dosya durumunu kontrol edin
3. Eksik dosyaları `git add .` ile ekleyin

### Hata 2: "No devices are booted"
**Çözüm**: Simülatör kapalı. Şu komutu çalıştırın:
```bash
xcrun simctl boot "iPhone 16"
```

### Hata 3: "Unable to find a device matching"
**Çözüm**: Mevcut simülatörleri kontrol edin:
```bash
xcrun simctl list devices
```

### Hata 4: "Project file not found"
**Çözüm**: Yanlış dizindesiniz. Şu adımları takip edin:
1. `pwd` ile mevcut dizini kontrol edin
2. `ls -la` ile dosyaları listeleyin
3. `SkincareAndRituals.xcodeproj` dosyasının varlığını kontrol edin

## 📱 Uygulama Özellikleri

Uygulama başarıyla çalıştığında şunları göreceksiniz:

### 🎯 Onboarding Ekranı
- Hoş geldin mesajı
- Uygulama özellikleri listesi
- "Start Survey" butonu

### 📊 Anket Akışı (6 Adım)
1. **İsim Girişi**: Kullanıcı adınızı girin
2. **Yaş Seçimi**: Yaş aralığınızı seçin
3. **Cilt Tipi**: Cilt tipinizi belirleyin
4. **Hassasiyet**: Cilt hassasiyetinizi seçin
5. **Motivasyon**: Cilt bakım hedeflerinizi seçin
6. **Bütçe**: Skincare bütçenizi belirleyin

## 🎨 Tasarım Özellikleri

- **Modern UI**: iOS Human Interface Guidelines uyumlu
- **Dark Mode**: Otomatik tema değişimi
- **Responsive**: Tüm iPhone boyutları için optimize
- **Animasyonlar**: Smooth geçişler ve kullanıcı deneyimi

## 🔍 Test Etme

Uygulamayı test etmek için:

1. **Onboarding**: "Start Survey" butonuna tıklayın
2. **Anket**: Her adımı dikkatlice doldurun
3. **Navigasyon**: İleri/geri butonlarını test edin
4. **Responsive**: Farklı simülatör boyutlarında test edin

## 📞 Destek

Eğer sorun yaşıyorsanız:

1. **GitHub Issues**: [Proje sayfasında](https://github.com/beyzatunca/SkincareAndRituals) issue açın
2. **README**: Detaylı dokümantasyon için README.md dosyasını okuyun
3. **Logs**: Xcode console'da hata mesajlarını kontrol edin

## ✅ Başarı Kriterleri

Uygulama başarıyla çalışıyor demektir eğer:
- ✅ Xcode'da build hatası yok
- ✅ Simülatörde uygulama açılıyor
- ✅ Onboarding ekranı görünüyor
- ✅ Anket akışı çalışıyor
- ✅ Tüm butonlar responsive

---

**🎉 Tebrikler!** Uygulamanız başarıyla çalışıyor. Artık modern SwiftUI tabanlı iOS uygulamanızı test edebilir ve geliştirmeye devam edebilirsiniz.
