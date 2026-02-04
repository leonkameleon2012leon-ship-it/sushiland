# Twoje Rośliny - AI Plant Care App 🌱🤖

Najbardziej zaawansowana aplikacja o roślinach w Flutter! Pełen system AI z rozpoznawaniem roślin, inteligentnym podlewaniem i diagnozą zdrowia.

## 🌟 Główne Funkcje

### 🤖 AI & Inteligentne Funkcje
- **Rozpoznawanie roślin AI** - Zrób zdjęcie rośliny, aby ją automatycznie zidentyfikować (Plant.id API)
- **Inteligentne podlewanie** - System dostosowuje harmonogram podlewania do pogody (temperatura, wilgotność, pora roku)
- **Diagnoza zdrowia** - Analiza zdjęć liści wykrywa problemy (przesuszenie, zalanie, szkodniki, choroby)
- **Widget pogody** - Wyświetla aktualną temperaturę i wilgotność z komunikatami
- **Powiadomienia push** - Przypomnienia o podlewaniu dostosowane do warunków

### 📊 Statystyki i Analityka
- Wykresy historii podlewania (ostatnie 30 dni)
- Średnia częstotliwość podlewania
- Najdłuższy streak dbania o roślinę
- Kalendarz podlewania
- Całkowita liczba podlewań

### 🌿 Zarządzanie Roślinami
- 20 pre-zdefiniowanych roślin z pełnymi danymi
- Rozszerzone informacje: wiek, wysokość, poziom trudności, wymagania świetlne
- Typ rośliny: doniczkowa, wisząca, sukulentowa, kwitnąca
- Ostrzeżenia o toksyczności dla zwierząt
- Własne notatki do każdej rośliny

### 🎨 UI/UX
- Piękne karty roślin z animacjami
- Płynne przejścia (fade, slide, scale)
- Zielona, naturalna paleta kolorów
- Hero animations
- Responsywny design

## 📋 Wymagania

- Flutter SDK: >=3.0.0 <4.0.0
- Dart SDK: >=3.0.0

## 📦 Zależności

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  permission_handler: ^11.0.1
  geolocator: ^10.1.0
  intl: ^0.18.1
  image_picker: ^1.0.7
  http: ^1.2.0
  image: ^4.1.7
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.2
  fl_chart: ^0.66.0
```

## 🚀 Instalacja

### 1. Sklonuj repozytorium
```bash
git clone https://github.com/leonkameleon2012leon-ship-it/sushiland.git
cd sushiland
```

### 2. Zainstaluj zależności
```bash
flutter pub get
```

### 3. Skonfiguruj klucze API (opcjonalne)

Aplikacja działa w trybie demo bez kluczy API, ale dla pełnej funkcjonalności potrzebujesz:

#### Plant.id API (Rozpoznawanie roślin)
1. Załóż darmowe konto na [plant.id](https://web.plant.id/)
2. Przejdź do [API Access](https://web.plant.id/api-access/)
3. Skopiuj swój API key
4. Otwórz `lib/config/api_config.dart`
5. Wklej klucz:
```dart
static const String plantIdApiKey = 'TWOJ_KLUCZ_TUTAJ';
```

#### OpenWeatherMap API (Pogoda)
1. Załóż darmowe konto na [openweathermap.org](https://openweathermap.org/)
2. Przejdź do [API Keys](https://home.openweathermap.org/api_keys)
3. Skopiuj swój API key
4. Otwórz `lib/config/api_config.dart`
5. Wklej klucz:
```dart
static const String weatherApiKey = 'TWOJ_KLUCZ_TUTAJ';
```

#### Tryb Demo
Jeśli nie chcesz konfigurować API keys, aplikacja automatycznie użyje trybu demo:
```dart
static const bool useDemoMode = true; // Zostaw true dla demo
```

### 4. Uruchom aplikację
```bash
flutter run
```

## 🔧 Uprawnienia

Aplikacja wymaga następujących uprawnień:

- **Lokalizacja** - Do sprawdzania warunków pogodowych dla twoich roślin
- **Powiadomienia** - Do przypomnień o podlewaniu
- **Aparat/Galeria** - Do skanowania i diagnozowania roślin

### Android
Uprawnienia są skonfigurowane w `android/app/src/main/AndroidManifest.xml`

### iOS
Opisy uprawnień są w `ios/Runner/Info.plist`

## 📁 Struktura Projektu

```
lib/
├── config/
│   └── api_config.dart              # Konfiguracja API keys
├── constants/
│   └── app_theme.dart               # Kolory i styl
├── models/
├── screens/
│   ├── onboarding/
│   │   ├── welcome_screen.dart      # Ekran powitalny
│   │   ├── name_screen.dart         # Wprowadzanie imienia
│   │   ├── permissions_screen.dart  # Prośba o uprawnienia
│   │   ├── plant_selection_screen.dart # Wybór roślin (20 dostępnych)
│   │   └── plant_details_screen.dart   # Formularz szczegółów rośliny
│   ├── home/
│   │   ├── dashboard_screen.dart    # Główny ekran z kartami roślin
│   │   └── plant_info_screen.dart   # Szczegóły pojedynczej rośliny
│   └── plant/
│       ├── plant_scan_screen.dart   # Skanowanie roślin AI
│       ├── plant_health_check_screen.dart # Diagnoza zdrowia
│       └── plant_stats_screen.dart  # Statystyki i wykresy
├── services/
│   ├── plant_storage_service.dart   # Persystencja danych
│   ├── plant_recognition_service.dart # AI rozpoznawanie
│   ├── weather_service.dart         # Pobieranie pogody
│   ├── smart_watering_service.dart  # Inteligentny algorytm
│   ├── plant_health_service.dart    # Analiza zdrowia
│   └── notification_service.dart    # Powiadomienia
├── utils/
└── main.dart
```

## 🎯 Szczegóły Funkcji

### 📸 Rozpoznawanie Roślin AI
- Otwórz aparat lub wybierz zdjęcie z galerii
- AI identyfikuje roślinę w ciągu 2-5 sekund
- Pokazuje nazwę polską i łacińską
- Procent pewności identyfikacji
- Automatyczne dopasowanie do bazy 20 roślin

### 🌡️ Inteligentne Podlewanie
**Algorytm uwzględnia:**
- Temperatura (>28°C = podlewaj częściej, <15°C = rzadziej)
- Wilgotność powietrza (<40% = częściej, >70% = rzadziej)
- Pora roku (zima +30%, lato -10%)
- Typ rośliny (sukulenty, wiszące, kwitnące)
- Wymagania świetlne (pełne słońce, półcień, cień)

**Wyświetla:**
- Aktualną temperaturę i wilgotność
- Komunikat o warunkach (np. "Dzisiaj gorąco - podlej wcześniej!")
- Dostosowane daty następnego podlewania

### 🔬 Diagnoza Zdrowia
**Wykrywa:**
- 💧 Zalanie (żółte liście)
- 🍂 Przesuszenie (brązowe końcówki)
- 🐛 Szkodniki (czarne plamy)
- 🦠 Choroby (przebarwienia)

**Zwraca:**
- Status: Zdrowa / Wymaga uwagi / Stan krytyczny
- Listę objawów
- Szczegółowe rekomendacje naprawy

### 📊 Statystyki
- Wykres słupkowy (ostatnie 10 podlewań)
- Filtry czasowe: 7D, 30D, 90D, Wszystko
- Karty statystyczne: całkowita liczba, średnia częstotliwość, streak
- Lista ostatnich podlewań z datami

## 🌱 Lista Roślin

Aplikacja zawiera 20 pre-zdefiniowanych roślin:

1. 🌿 Monstera - Łatwa, półcień, toksyczna
2. 🪴 Aloes - Łatwy, pełne słońce, sukulentowa
3. 🌱 Paproć - Średnia, cień, wisząca
4. 🌵 Kaktus - Łatwy, pełne słońce, sukulentowa
5. 🌺 Storczyk - Trudny, półcień, kwitnąca
6. 🍃 Filodendron - Łatwy, półcień, toksyczny
7. 🌿 Sansewieria - Łatwa, półcień
8. 🌱 Pothos - Łatwy, półcień, toksyczny
9. 🌴 Palma Areka - Średnia, pełne słońce
10. 🌸 Begonia - Średnia, półcień, toksyczna
11. 🍀 Koniczyna szczęścia - Łatwa, pełne słońce
12. 🌵 Sukulenty mix - Łatwe, pełne słońce
13. 🌺 Hibiskus - Trudny, pełne słońce
14. 🪴 Zamiokulkas - Łatwy, cień, toksyczny
15. 🌿 Skrzydłokwiat - Łatwy, cień, toksyczny
16. 🌱 Bazylka - Średnia, pełne słońce
17. 🌷 Tulipan - Średnia, pełne słońce, toksyczny
18. 🌹 Róża miniaturowa - Trudna, pełne słońce
19. 🍃 Dracena - Łatwa, półcień, toksyczna
20. 🌾 Trawa ozdobna - Łatwa, pełne słońce

## 🎨 Styling
- Search functionality
- Multi-select with animated checkmarks
- Scale animations on card selection

### Dashboard
- Personalized greeting based on time of day
- Plant status cards with:
  - Water level indicators
  - Days until next watering
  - Quick water button
- Empty state when no plants added
- Ability to add more plants

## Plant Data

Each plant includes:
- Name (e.g., Monstera, Aloes)
- Emoji icon
- Description
- Watering frequency (in days)

## Styling

- **Primary Green**: `#4CAF50`
- **Light Green**: `#81C784`
- **Dark Green**: `#2E7D32`
- **Background**: `#E8F5E9`
- **Font**: System default with custom weights

## Future Enhancements

- [ ] Add plant photos from device camera
- [ ] Weather-based watering suggestions
- [ ] Push notifications for watering reminders
- [ ] Plant health tracking
- [ ] Growth timeline
- [ ] Community features

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

- **Primary Green**: `#4CAF50`
- **Light Green**: `#81C784`
- **Dark Green**: `#2E7D32`
- **Background**: `#E8F5E9`
- **Rounded corners**: 20px
- **Shadows**: Subtle elevation
- **Animations**: 600ms, Curves.easeInOut

## 🔔 Powiadomienia

- Przypomnienia o podlewaniu (codziennie o 9:00)
- Alerty pogodowe (gdy zmienia się pogoda)
- Ostrzeżenia zdrowotne roślin
- Możliwość wyłączenia w ustawieniach

## 🧪 Tryb Demo

Aplikacja działa w trybie demo bez API keys:
- **Rozpoznawanie roślin**: Zwraca przykładową Monsterę
- **Pogoda**: Pokazuje przykładowe dane (23°C, 55% wilgotność)
- **Diagnoza**: Losowa diagnoza dla testów

## 🚨 Troubleshooting

### Błąd kompilacji
```bash
flutter clean
flutter pub get
flutter run
```

### Brak uprawnień
Upewnij się, że aplikacja ma uprawnienia do:
- Lokalizacji (dla pogody)
- Powiadomień (dla przypomnień)
- Aparatu (dla skanowania)

### API nie działa
1. Sprawdź czy klucze API są poprawne w `lib/config/api_config.dart`
2. Ustaw `useDemoMode = false` jeśli masz klucze
3. Upewnij się, że masz połączenie internetowe

## 📝 Licencja

Ten projekt jest open source i dostępny na licencji MIT.

## 🤝 Contributing

Contribution są mile widziane! Proszę śmiało tworzyć Pull Requesty.

## 👨‍💻 Autorzy

- System AI i integracje utworzone przez GitHub Copilot
- Projekt bazowy: Plant Care App

## 🙏 Podziękowania

- [Plant.id](https://plant.id) - API rozpoznawania roślin
- [OpenWeatherMap](https://openweathermap.org) - API pogody
- [Flutter](https://flutter.dev) - Framework
- [fl_chart](https://pub.dev/packages/fl_chart) - Wykresy

---

**Made with 💚 and Flutter**
