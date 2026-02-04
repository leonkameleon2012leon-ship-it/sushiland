# 🌱 Twoje Rośliny - Kompletna Aplikacja Flutter

## Przegląd

Aplikacja do dbania o rośliny domowe z pięknym, uspokajającym interfejsem użytkownika w języku polskim. Zawiera pełny przepływ onboardingu, system podlewania roślin z licznikiem dni oraz zapis danych lokalnie.

## ✨ Funkcje

### Ekrany (5 kompletnych ekranów)

1. **Ekran Powitalny** 
   - Animowane liście delikatnie kołyszące się
   - Zielone tło z gradientem
   - Płynna animacja fade-in

2. **Wprowadzanie Imienia**
   - Personalizowane powitanie
   - Animacja slide-in od dołu
   - Walidacja inputu
   - Zapis w SharedPreferences

3. **Uprawnienia**
   - Karta dla lokalizacji
   - Karta dla powiadomień
   - Przyjazne opisy dla każdego uprawnienia
   - Status wizualny (zielony gdy przyznane)

4. **Wybór Roślin**
   - 8 predefiniowanych roślin z emoji
   - Funkcja wyszukiwania
   - Wielokrotny wybór
   - Animowane checkmarki
   - Animacje skali przy wyborze

5. **Panel Główny**
   - Spersonalizowane powitanie według pory dnia
   - Karty statusu roślin z:
     - Wskaźnikami poziomu wody
     - Dni do następnego podlewania
     - Przycisk szybkiego podlewania
   - Stan pusty gdy brak roślin
   - Możliwość dodawania kolejnych roślin

### 💾 Persistencja Danych

- **Zapis roślin**: Wszystkie rośliny i daty podlewania są zapisywane lokalnie
- **Zapis onboardingu**: Aplikacja pamięta, czy użytkownik ukończył onboarding
- **Zapis imienia**: Imię użytkownika jest przechowywane trwale
- **Automatyczne ładowanie**: Przy ponownym uruchomieniu aplikacja ładuje wszystkie dane

### 🎨 Animacje

- ✅ Kołyszące się liście (ciągłe)
- ✅ Przejścia fade-in
- ✅ Przejścia slide
- ✅ Animacje skali
- ✅ Stopniowe wejścia elementów
- ✅ Wszystkie używają Curves.easeInOut
- ✅ Płynne przejścia między ekranami (600ms)

### 🎨 Kolorystyka

- **Główny Zielony**: `#4CAF50`
- **Jasny Zielony**: `#81C784`
- **Ciemny Zielony**: `#2E7D32`
- **Tło**: `#E8F5E9`
- **Tekst Ciemny**: `#1B5E20`
- **Tekst Jasny**: `#66BB6A`

## 📦 Zależności

Wszystkie zależności są już skonfigurowane w `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  permission_handler: ^11.0.1
  geolocator: ^10.1.0
```

## 📱 Konfiguracja Platformy

### Android

Uprawnienia są skonfigurowane w `android/app/src/main/AndroidManifest.xml`:
- ✅ ACCESS_FINE_LOCATION
- ✅ ACCESS_COARSE_LOCATION
- ✅ POST_NOTIFICATIONS
- ✅ Nazwa aplikacji: "Twoje Rośliny"

### iOS

Opisy uprawnień w `ios/Runner/Info.plist`:
- ✅ NSLocationWhenInUseUsageDescription
- ✅ NSLocationAlwaysUsageDescription
- ✅ Nazwa wyświetlana: "Twoje Rośliny"

## 🌿 Dostępne Rośliny

1. **Monstera** 🌿 - Łatwa w pielęgnacji (podlewanie co 7 dni)
2. **Aloes** 🪴 - Nie wymaga dużo wody (co 14 dni)
3. **Paproć** 🌱 - Lubi wilgotne środowisko (co 5 dni)
4. **Kaktus** 🌵 - Bardzo wytrzymały (co 21 dni)
5. **Storczyk** 🌺 - Piękne kwiaty (co 10 dni)
6. **Filodendron** 🍃 - Duże zielone liście (co 7 dni)
7. **Sansewieria** 🌿 - Bardzo odporna (co 14 dni)
8. **Pothos** 🌱 - Oczyszcza powietrze (co 7 dni)

## 🚀 Instalacja i Uruchomienie

### Krok 1: Zainstaluj Flutter

Jeśli nie masz Fluttera:
```bash
# Pobierz Flutter SDK z https://flutter.dev/docs/get-started/install
# Dodaj Flutter do PATH
```

### Krok 2: Sklonuj Repozytorium

```bash
git clone https://github.com/leonkameleon2012leon-ship-it/sushiland.git
cd sushiland
```

### Krok 3: Pobierz Zależności

```bash
flutter pub get
```

### Krok 4: Uruchom Aplikację

```bash
# Na urządzeniu podłączonym lub emulatorze
flutter run

# Na konkretnym urządzeniu
flutter run -d <device_id>

# Lista dostępnych urządzeń
flutter devices
```

### Krok 5: Zbuduj dla Produkcji

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📂 Struktura Projektu

```
lib/
├── constants/
│   └── app_theme.dart              # Konfiguracja motywu i kolorów
├── services/
│   └── plant_storage_service.dart  # Serwis zapisu/odczytu danych
├── screens/
│   ├── onboarding/
│   │   ├── welcome_screen.dart     # Ekran powitalny z animacjami
│   │   ├── name_screen.dart        # Wprowadzanie imienia
│   │   ├── permissions_screen.dart # Prośby o uprawnienia
│   │   └── plant_selection_screen.dart # Wybór roślin
│   └── home/
│       └── dashboard_screen.dart   # Główny panel z roślinami
└── main.dart                       # Punkt wejścia aplikacji
```

## 🔧 Szczegóły Techniczne

### Zarządzanie Stanem

- Stateful widgets z AnimationControllers
- SharedPreferences dla persystencji
- Lokalne zarządzanie stanem w widgetach

### Animacje

- AnimationController dla ciągłych animacji (liście)
- TweenAnimationBuilder dla jednorazowych animacji
- AnimatedContainer dla zmian właściwości
- PageRouteBuilder dla przejść między ekranami
- Wszystkie animacje używają Curves.easeInOut dla naturalnego ruchu

### Przechowywanie Danych

- **SharedPreferences** dla prostych danych (imię, status onboardingu)
- **JSON serialization** dla złożonych obiektów (rośliny z datami)
- Automatyczny zapis przy każdej zmianie
- Automatyczne ładowanie przy starcie aplikacji

## 🎯 Funkcjonalność Production-Ready

✅ **Bez placeholder'ów** - Wszystkie teksty, funkcje i ekrany są kompletne
✅ **Obsługa błędów** - Try-catch w operacjach I/O
✅ **Walidacja** - Sprawdzanie pustych pól, duplikatów
✅ **Persystencja** - Wszystkie dane są zapisywane
✅ **Animacje** - Płynne i profesjonalne
✅ **UI/UX** - Intuicyjny interfejs z feedbackiem
✅ **Język polski** - Kompletna lokalizacja UI
✅ **Uprawnienia** - Prawidłowa konfiguracja dla Android i iOS

## 📱 Testowanie

### Testowanie na Emulatorze

```bash
# Android
flutter emulators
flutter emulators --launch <emulator_id>
flutter run

# iOS (tylko na macOS)
open -a Simulator
flutter run
```

### Testowanie na Rzeczywistym Urządzeniu

```bash
# Podłącz urządzenie przez USB
# Włącz tryb deweloperski (Android) lub zaufaj komputerowi (iOS)
flutter devices
flutter run -d <device_id>
```

## 🐛 Rozwiązywanie Problemów

### Problem: "flutter: command not found"
```bash
# Dodaj Flutter do PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

### Problem: Brak uprawnień na Androidzie
- Sprawdź AndroidManifest.xml
- Przeinstaluj aplikację: `flutter run --uninstall-first`

### Problem: Błąd build na iOS
- Uruchom: `cd ios && pod install && cd ..`
- Sprawdź wersję Xcode

### Problem: Dane nie są zapisywane
- Sprawdź logi: `flutter logs`
- Wyczyść dane aplikacji i spróbuj ponownie

## 📖 Przykłady Użycia

### Dodawanie Nowej Rośliny do Listy

Edytuj `lib/screens/onboarding/plant_selection_screen.dart`:

```dart
const List<Plant> availablePlants = [
  // Istniejące rośliny...
  Plant(
    name: 'Nowa Roślina',
    emoji: '🌸',
    description: 'Opis rośliny',
    wateringDays: 7,
  ),
];
```

### Zmiana Motywu Kolorystycznego

Edytuj `lib/constants/app_theme.dart`:

```dart
static const Color primaryGreen = Color(0xFF4CAF50); // Zmień na swój kolor
```

### Dodawanie Nowych Uprawnień

1. Dodaj do `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

2. Dodaj do `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Opis użycia aparatu</string>
```

## 🔒 Prywatność

Aplikacja:
- ✅ Przechowuje dane tylko lokalnie na urządzeniu
- ✅ Nie wysyła danych do zewnętrznych serwerów
- ✅ Prosi o uprawnienia z przejrzystymi wyjaśnieniami
- ✅ Działa offline
- ✅ Użytkownik ma pełną kontrolę nad swoimi danymi

## 📄 Licencja

Ten projekt jest dostępny na licencji MIT.

## 🤝 Wsparcie

Jeśli masz pytania lub problemy:
1. Sprawdź dokumentację Flutter: https://flutter.dev/docs
2. Sprawdź logi: `flutter logs`
3. Wyczyść projekt: `flutter clean && flutter pub get`
4. Przebuduj: `flutter run`

## 🎉 Gotowe do Użycia!

Aplikacja jest w pełni kompletna i gotowa do produkcji. Wszystkie pliki kodu są dostępne w repozytorium i gotowe do skopiowania. Nie ma placeholder'ów, wszystkie funkcje działają, a kod jest production-ready.

**Miłego korzystania z aplikacji Twoje Rośliny! 🌱**
