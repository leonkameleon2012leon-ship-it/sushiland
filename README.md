# Twoje Rośliny - Plant Care App 🌱

A beautiful, calm, and animated Flutter mobile application for taking care of house plants.

## Features

### Onboarding Flow
1. **Welcome Screen** - Green background with gently swaying animated leaves
2. **Name Input** - Personalized greeting with smooth slide-in animation
3. **Permissions** - Request for location and notifications with friendly messages
4. **Plant Selection** - Browse and select plants with search functionality

### Main Dashboard
- Beautiful plant cards showing status and watering needs
- Interactive watering system with countdown
- Smooth animations throughout the app
- Green, plant-themed color scheme

## Design Principles

- **Calm & Peaceful**: Green color palette inspired by nature
- **Fluid Animations**: Using Flutter's AnimatedContainer, PageView, Hero transitions
- **Natural Flow**: Smooth transitions with Curves.easeInOut
- **Living Feel**: Plants "talk" to users with friendly messages

## Requirements

- Flutter SDK: >=3.0.0 <4.0.0
- Dart SDK: >=3.0.0

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  permission_handler: ^11.0.1
  geolocator: ^10.1.0
```

## Installation

1. Clone the repository
```bash
git clone https://github.com/leonkameleon2012leon-ship-it/sushiland.git
cd sushiland
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Permissions

The app requests the following permissions:

- **Location**: To check weather conditions for your plants
- **Notifications**: To remind you about watering schedules

### Android
Permissions are configured in `android/app/src/main/AndroidManifest.xml`

### iOS
Location usage description is configured in `ios/Runner/Info.plist`

## App Structure

```
lib/
├── constants/
│   └── app_theme.dart          # Theme and color definitions
├── screens/
│   ├── onboarding/
│   │   ├── welcome_screen.dart         # Welcome with animated leaves
│   │   ├── name_screen.dart            # Name input
│   │   ├── permissions_screen.dart     # Permission requests
│   │   └── plant_selection_screen.dart # Plant selection
│   └── home/
│       └── dashboard_screen.dart       # Main plant dashboard
└── main.dart                   # App entry point
```

## Features in Detail

### Welcome Screen
- Animated leaves that sway gently
- Fade-in animation on load
- Smooth transition to name screen

### Name Input
- Slide-from-bottom animation
- Auto-advances when name is entered
- Stored in SharedPreferences

### Permissions
- Beautiful card-based UI for each permission
- Clear explanations for why each permission is needed
- Can proceed even without granting permissions

### Plant Selection
- 8 pre-defined plants with emoji icons
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
