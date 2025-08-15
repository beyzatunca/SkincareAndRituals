# Skincare & Rituals iOS App

Modern SwiftUI tabanlı iOS uygulaması - kişiselleştirilmiş cilt bakımı rutinleri önerisi için anket uygulaması.

## 🚀 Özellikler

- **Modern SwiftUI Tasarım**: iOS Human Interface Guidelines'a uygun temiz ve modern arayüz
- **MVVM Mimarisi**: Temiz kod yapısı ve sürdürülebilir mimari
- **Kişiselleştirilmiş Anket**: 6 adımlı detaylı cilt analizi
- **Responsive Tasarım**: Tüm iPhone boyutları için optimize edilmiş
- **Dark Mode Desteği**: Otomatik tema değişimi
- **Animasyonlar**: Smooth geçişler ve kullanıcı deneyimi

## 📱 Ekranlar

### 1. Onboarding Ekranı
- Hoş geldin mesajı
- Uygulama özellikleri
- "Start Survey" CTA butonu

### 2. Anket Akışı (6 Adım)
1. **İsim**: Kullanıcı adı girişi
2. **Yaş**: Yaş aralığı seçimi (13-17, 18-24, 25-34, 35-44, 45-54, 55+)
3. **Cilt Tipi**: Cilt tipi seçimi (Oily, Dry, Combination, Normal)
4. **Hassasiyet**: Cilt hassasiyeti (Sensitive/Not Sensitive)
5. **Motivasyon**: Cilt bakım hedefleri (çoklu seçim)
6. **Bütçe**: Skincare bütçe aralığı seçimi

## 🏗️ Proje Yapısı

```
SkincareAndRituals/
├── Features/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   └── Survey/
│       ├── SurveyView.swift
│       └── QuestionViews.swift
├── Core/
│   ├── Models/
│   │   └── SurveyModels.swift
│   └── ViewModels/
│       └── SurveyViewModel.swift
├── UI/
│   ├── Components/
│   │   └── CommonComponents.swift
│   └── Styles/
│       └── AppTheme.swift
├── Resources/
│   └── Assets/
│       └── Assets.xcassets/
├── SkincareAndRitualsApp.swift
└── ContentView.swift
```

## 🎨 Tasarım Sistemi

### Renkler
- **Primary**: Mor tonları (#6633CC)
- **Secondary**: Açık mor (#9966FF)
- **Background**: Açık gri (#F8F8F8)
- **Surface**: Beyaz (#FFFFFF)
- **Text Primary**: Koyu gri (#333333)
- **Text Secondary**: Orta gri (#666666)

### Tipografi
- **Large Title**: 34pt, Bold
- **Title 1**: 28pt, Bold
- **Title 2**: 22pt, Semibold
- **Headline**: 17pt, Semibold
- **Body**: 17pt, Regular
- **Caption**: 12pt, Regular

### Bileşenler
- **Primary Button**: Gradient arka plan, 56pt yükseklik
- **Secondary Button**: Outline stil
- **Selection Card**: Seçilebilir kartlar
- **Progress Bar**: İlerleme göstergesi
- **Custom Text Field**: Özelleştirilmiş metin girişi

## 🛠️ Teknik Detaylar

### Gereksinimler
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Kullanılan Teknolojiler
- **SwiftUI**: Modern UI framework
- **Combine**: Reactive programming
- **MVVM**: Model-View-ViewModel pattern
- **@StateObject/@ObservedObject**: State management
- **GeometryReader**: Responsive layout
- **SF Symbols**: Apple'ın icon sistemi

### Mimari Özellikler
- **Protocol-Oriented Programming**: Swift best practices
- **Value Types**: Struct kullanımı
- **Dependency Injection**: ViewModel injection
- **Separation of Concerns**: Temiz kod yapısı
- **Reusable Components**: Yeniden kullanılabilir UI bileşenleri

## 🚀 Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/beyzatunca/SkincareAndRituals.git
cd SkincareAndRituals
```

2. Xcode'da açın:
```bash
open SkincareAndRituals.xcodeproj
```

3. Simülatörde çalıştırın:
- iPhone 16 simülatörünü seçin
- Cmd+R ile build edin

## 📊 Anket Verileri

### Toplanan Veriler
- Kullanıcı adı
- Yaş aralığı
- Cilt tipi
- Cilt hassasiyeti
- Cilt bakım hedefleri (çoklu)
- Bütçe aralığı

### Veri Yapısı
```swift
struct SurveyResponse: Codable {
    var name: String
    var age: AgeRange
    var skinType: SkinType
    var isSensitive: Bool
    var motivations: Set<SkinMotivation>
    var budget: BudgetRange
}
```

## 🎯 Gelecek Özellikler

- [ ] Chat entegrasyonu ile cilt analizi
- [ ] Kişiselleştirilmiş ürün önerileri
- [ ] Rutin takip sistemi
- [ ] Push notifications
- [ ] Sosyal medya entegrasyonu
- [ ] Ürün veritabanı
- [ ] Kullanıcı profilleri
- [ ] İlerleme takibi

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 👨‍💻 Geliştirici

**Beyza Erdemli**
- GitHub: [@beyzatunca](https://github.com/beyzatunca)
- LinkedIn: [Beyza Erdemli](https://linkedin.com/in/beyzaerdemli)

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!
