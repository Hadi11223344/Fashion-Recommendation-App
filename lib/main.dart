import 'package:fashion_app/screens/about_you_screen.dart';
import 'package:fashion_app/screens/forget_password_screen.dart';
import 'package:fashion_app/screens/holder_screen.dart';
import 'package:fashion_app/screens/home_screen.dart';
import 'package:fashion_app/screens/my_looks_screen.dart';
import 'package:fashion_app/screens/onboarding_screen.dart';
import 'package:fashion_app/screens/personalization_splash_screen.dart';
import 'package:fashion_app/screens/profile_screen.dart';
import 'package:fashion_app/screens/signin_screen.dart';
import 'package:fashion_app/screens/signup_screen.dart';
import 'package:fashion_app/screens/wardrobe_screen.dart';
import 'package:flutter/material.dart';
import 'package:fashion_app/screens/splash_screen.dart';
import '../theme.dart'; // Import theme file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white
      ) ,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/signup': (context) => const SignupScreen(),
        '/signin': (context) => const SigninScreen(),
        '/aboutyou': (context) => const AboutYouScreen(),
        '/forgetpassword': (context)=> const ForgetPasswordScreen(),
        '/personalizationsplash': (context) => const PersonalizationSplashScreen(),
        'profile':(context) => const ProfileScreen(),
        'holder':(context) => const HolderScreen(),
        'home':(context) => const HomeScreen(),
        'wardrobe':(context) => const WardrobeScreen(),
        'mylooks':(context) => const MyLooksScreen(),

      },
    );
  }
}