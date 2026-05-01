import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemread/screens/splash_screen.dart';
import 'package:lemread/screens/onboarding_screen.dart';
import 'package:lemread/screens/home_screen.dart';
import 'package:lemread/screens/category_detail_screen.dart';
import 'package:lemread/screens/article_screen.dart';
import 'package:lemread/screens/quiz_screen.dart';
import 'package:lemread/screens/quiz_result_screen.dart';
import 'package:lemread/screens/coming_soon_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vfjvvlynxowepuqepulz.supabase.co',
    anonKey: 'sb_publishable_GgjskjY-7yEm95uq1tTpoA_WOooF4gu',
  );
  runApp(const LemReadApp());
}

class LemReadApp extends StatelessWidget {
  const LemReadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LemRead',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/coming-soon': (context) => const ComingSoonScreen(),
      },
    );
  }
}