# NapCoin - Earn While You Nap

A Flutter-based mobile app for the NAPCOIN token mining project. This app allows users to earn NAP tokens through a unique "sleep mining" mechanism.

## Features

- **Onboarding Screen**: Beautiful parallax effect with "EARN WHILE NAP" branding
- **Authentication**: Firebase-powered sign up and login functionality
- **Home Screen**: Real-time token balance display with glowing animations
- **Mining Mode**: 12-hour mining sessions with sleeping panda animations
- **Background Mining**: Continues mining even when app is closed
- **Referral System**: Increase mining rate through referrals

## Mining Mechanics

- **Base Rate**: 4.3333 NAP/hr
- **Referral Bonus**: +1.3333 NAP/hr per referral
- **Session Duration**: 12 hours maximum
- **Background Processing**: Mining continues when app is minimized

## Technical Stack

- **Framework**: Flutter
- **Authentication**: Firebase Auth
- **Data Storage**: SharedPreferences for local data
- **State Management**: StatefulWidget with AnimationController
- **Platform**: Android & iOS

## Getting Started

### Prerequisites

- Flutter SDK (3.7.9 or later)
- Firebase project with Authentication enabled
- Android Studio / Xcode for development

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/staraircool/Nap1.git
   cd Nap1
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Place your `google-services.json` in `android/app/`
   - Place your `GoogleService-Info.plist` in `ios/Runner/`

4. Run the app:
   ```bash
   flutter run
   ```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ipa --release
```

## Codemagic CI/CD

This project includes a `codemagic.yaml` configuration file for automated building and deployment:

- **Android Workflow**: Builds APK and publishes to Google Play
- **iOS Workflow**: Builds IPA and publishes to App Store Connect
- **Automated Testing**: Runs Flutter analyze and unit tests

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── onboarding_screen.dart    # Welcome screen with parallax
│   ├── auth_screen.dart          # Sign up/Login screen
│   ├── home_screen.dart          # Token balance display
│   └── mining_screen.dart        # Mining interface
└── services/
    ├── auth_service.dart         # Firebase authentication
    └── mining_service.dart       # Background mining logic
```

## UI Design

The app follows the provided design mockups with:
- Purple gradient backgrounds
- Panda-themed illustrations
- Smooth swipe-up navigation
- Glowing token display effects
- Professional button styling

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is proprietary software for the NAPCOIN project.

## Support

For technical support or questions, please contact the development team.

