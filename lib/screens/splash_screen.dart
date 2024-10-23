import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package
import 'package:flutter/material.dart';
import 'package:service_bay/screens/sign_in_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check the current user and navigate accordingly
    checkCurrentUser();
  }

  void checkCurrentUser() async {
    // Simulate a delay for splash screen
    await Future.delayed(Duration(seconds: 3));

    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Navigate based on whether a user is signed in or not
    if (currentUser != null) {
      // User is signed in, navigate to HomeScreen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } else {
      // No user signed in, navigate to SignInScreen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width  = size.width;

    return  Scaffold(
      backgroundColor: Color(0XFFffffff), // You can change the background color
      body: Center(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Replace with your app's logo or image

            Image.asset(
              'assets/images/ichiban_logo.png', // Your image path
              height: height * 0.3,
            ),

            Positioned(
              top: height *0.2,
              left: width*0.22,
              child: Row(
                children: [
                  Icon(
                    Icons.car_repair_sharp, // Example icon
                    size: width*.09,
                    color: Colors.black,
                  ),
               const  Text(
                    'For everything cars',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
