# Skincare & Rituals iOS App

Modern SwiftUI tabanlı iOS uygulaması - kişiselleştirilmiş cilt bakımı rutinleri önerisi için anket uygulaması.

## 🚀 Özellikler

- **Modern SwiftUI Tasarım**: iOS Human Interface Guidelines'a uygun temiz ve modern arayüz
- **MVVM Mimarisi**: Temiz kod yapısı ve sürdürülebilir mimari
- **Kişiselleştirilmiş Anket**: 6 adımlı detaylı cilt analizi
- **Responsive Tasarım**: Tüm iPhone boyutları için optimize edilmiş
- **Dark Mode Desteği**: Otomatik tema değişimi
- **Animasyonlar**: Smooth geçişler ve kullanıcı deneyimi
- **Tab Bar Navigation**: 5 ana sekme ile kolay navigasyon
- **Product Scanner**: Ürün tarama ve analiz özelliği
- **Face Analysis**: Yüz analizi ve cilt durumu değerlendirmesi
- **Skin Journal**: Günlük cilt durumu takibi
- **Routine Tracking**: Sabah ve akşam rutin takibi
- **Daily Tips**: 365 günlük cilt bakım ipuçları
- **Product Database**: Ürün veritabanı ve detaylı bilgiler
- **DIY Skincare Recipes**: Evde yapılabilecek doğal cilt bakım tarifleri
- **Explore Routines**: Farklı zorluk seviyelerinde cilt bakım rutinleri
- **Skincare Application Guides**: Uygulama teknikleri ve face gym rehberleri

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

### 3. Ana Ekranlar (Tab Bar)
- **🏠 Home**: Ana dashboard ve rutin takibi
- **🔍 Products**: Ürün arama ve detayları
- **📷 Scanner**: Ürün tarama ve analiz
- **👤 Profile**: Kullanıcı profili ve ayarlar
- **🔬 Analysis**: Yüz analizi ve cilt durumu

### 4. Özel Özellikler
- **Skin Journal**: Günlük cilt durumu takibi
- **Morning/Evening Routine**: Rehberli rutin takibi
- **Daily Tips**: 365 günlük cilt bakım ipuçları
- **Product Database**: Detaylı ürün bilgileri
- **Face Analysis**: AI destekli yüz analizi

### 5. Discovery Ekranı (Explore Tab)
- **Explore Routines**: 6 farklı cilt bakım rutini
  - Essential Routine (Başlangıç)
  - Complete Routine (Orta)
  - Power Routine (İleri)
  - High-Performance Routine (Uzman)
  - SOS Skincare Routine (Acil)
  - Skin Cycling Routine (Döngüsel)

- **Skincare Application & Face Gym Guides**: 20 uygulama rehberi
  - Temizlik ürünleri (Micellar Water, Cleansing Balm, vs.)
  - Tedavi ürünleri (Enzyme Power, Chemical Peeling, vs.)
  - Nemlendirme ürünleri (Face Cream, Sheet Mask, vs.)
  - Koruma ürünleri (SPF, Face Oil, vs.)

- **DIY Skincare**: 4 kategoride doğal tarifler
  - **Hydration**: Nemlendirici maskeler (2 tarif)
  - **Brightening**: Parlaklık veren tarifler (2 tarif)
  - **Nourishing**: Besleyici maskeler (2 tarif)
  - **Exfoliation**: Peeling ve scrub tarifleri (2 tarif)

## 🏗️ Proje Yapısı

```
SkincareAndRituals/
├── Features/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Survey/
│   │   ├── SurveyView.swift
│   │   └── QuestionViews.swift
│   ├── Home/
│   │   └── SkincareRitualsHomeView.swift
│   ├── Products/
│   │   ├── ProductsView.swift
│   │   └── ProductDetailView.swift
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   ├── MySkinProfileView.swift
│   │   └── AppSettingsView.swift
│   ├── Scanner/
│   │   └── ProductScannerView.swift
│   ├── FaceAnalysis/
│   │   ├── FaceAnalysisView.swift
│   │   └── FaceAnalysisViewModel.swift
│   └── Explore/ (Empty - ExploreRoutinesView integrated into ContentView.swift)
├── Core/
│   ├── Models/
│   │   ├── SurveyModels.swift
│   │   ├── ProductModels.swift
│   │   ├── ProfileModels.swift
│   │   ├── AppTab.swift
│   │   └── SkincareTips.swift
│   └── ViewModels/
│       ├── SurveyViewModel.swift
│       ├── ProductsViewModel.swift
│       └── ProductDetailViewModel.swift
├── UI/
│   ├── Components/
│   │   ├── CommonComponents.swift
│   │   ├── AppTabBar.swift
│   │   ├── ProductCardView.swift
│   │   └── FlaggedIngredientView.swift
│   ├── Styles/
│   │   └── AppTheme.swift
│   └── Views/
│       └── RootContainerView.swift
├── Resources/
│   ├── Assets/
│   │   └── Assets.xcassets/
│   │       ├── AppIcon.appiconset/
│   │       ├── PrimaryColor.colorset/
│   │       ├── SecondaryColor.colorset/
│   │       ├── BackgroundColor.colorset/
│   │       ├── SurfaceColor.colorset/
│   │       ├── TextPrimary.colorset/
│   │       └── TextSecondary.colorset/
│   └── SampleProducts.json
├── Preview Content/
│   └── Preview Assets.xcassets/
├── SkincareAndRitualsApp.swift
├── ContentView.swift (Contains all models and views)
│   ├── Models: Routine, SkincareGuide, DIYRecipe, Recipe
│   ├── Views: ExploreRoutinesView, RecipeCardView, RecipeDetailView
│   ├── Sample Data: Routines, Skincare Guides, DIY Recipes, Recipes
│   └── Components: RoutineCardView, SkincareGuideCardView, DIYRecipeCardView
└── Info.plist
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

## 🍯 DIY Skincare Recipes

### Tarif Kategorileri
- **Hydration**: Nemlendirici maskeler ve tedaviler
- **Brightening**: Parlaklık veren ve aydınlatıcı tarifler
- **Nourishing**: Besleyici ve onarıcı maskeler
- **Exfoliation**: Peeling ve scrub tarifleri

### Tarif Yapısı
```swift
struct Recipe: Identifiable {
    let title: String
    let imageName: String
    let ingredients: [String]
    let steps: [String]
    let skinConcern: SkinConcern
    let timeNeeded: Int // dakika
    let difficulty: RecipeDifficulty
    let category: RecipeCategory
}

enum SkinConcern: String, CaseIterable {
    case dryness, dullness, acne, aging, sensitivity, oiliness
}

enum RecipeDifficulty: String, CaseIterable {
    case easy = "⭐"
    case medium = "⭐⭐"
    case hard = "⭐⭐⭐"
}
```

### Örnek Tarifler
1. **Honey & Yogurt Hydrating Mask** (15 dk, ⭐ Easy)
2. **Turmeric Brightening Mask** (10 dk, ⭐ Easy)
3. **Oatmeal Nourishing Mask** (15 dk, ⭐ Easy)
4. **Sugar & Coffee Scrub** (5 dk, ⭐ Easy)

## 🎯 Gelecek Özellikler

- [x] ✅ Tab Bar Navigation sistemi
- [x] ✅ Product Scanner özelliği
- [x] ✅ Face Analysis modülü
- [x] ✅ Skin Journal günlük takip
- [x] ✅ Morning/Evening Routine tracking
- [x] ✅ Daily Tips sistemi (365 gün)
- [x] ✅ Product Database
- [x] ✅ Enhanced UI/UX tasarımı
- [x] ✅ Explore Routines (6 farklı rutin)
- [x] ✅ Skincare Application Guides (20 uygulama rehberi)
- [x] ✅ DIY Skincare Recipes (8 doğal tarif)
- [x] ✅ Recipe Detail View with navigation
- [x] ✅ Modern card design with blurry backgrounds
- [ ] 🔄 Chat entegrasyonu ile cilt analizi
- [ ] 🔄 Kişiselleştirilmiş ürün önerileri
- [ ] 🔄 Push notifications
- [ ] 🔄 Sosyal medya entegrasyonu
- [ ] 🔄 Kullanıcı profilleri
- [ ] 🔄 İlerleme takibi
- [ ] 🔄 Cloud sync
- [ ] 🔄 Offline mode
- [ ] 🔄 Recipe favorileri ve koleksiyonları
- [ ] 🔄 Tarif paylaşımı
- [ ] 🔄 Malzeme listesi ve alışveriş özelliği

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
