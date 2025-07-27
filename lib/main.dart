import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mining_screen.dart';
import 'services/mining_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MiningService.initialize();
  runApp(const NapCoinApp());
}

class NapCoinApp extends StatelessWidget {
  const NapCoinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NapCoin',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
      ),
      home: const OnboardingScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/mining': (context) => const MiningScreen(),
      },
    );
  }
}

