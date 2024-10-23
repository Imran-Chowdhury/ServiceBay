import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_bay/screens/booking_screen.dart';
import 'package:service_bay/screens/home_screen.dart';
import 'package:service_bay/screens/sign_in_screen.dart';
import 'package:service_bay/screens/sign_up_screen.dart';
import 'package:service_bay/screens/splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp( MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      // initialRoute: '/signUp',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signIn': (context) => SignInScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/book':(context) => const BookingScreen(),
      },
    );
  }
}
