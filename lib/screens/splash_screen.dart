import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package
import 'package:flutter/material.dart';
import 'package:service_bay/controllers/auth_controller.dart';
import 'package:service_bay/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Make sure to import Riverpod




// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//
//     Future.microtask(() {
//       checkCurrentUser();
//     });
//   }

//   Future<void> checkCurrentUser() async {
//     // Add delay to simulate splash screen duration
//     await Future.delayed(const Duration(seconds: 3));
//
//     // Get the current user
//     User? currentUser = FirebaseAuth.instance.currentUser;
//
//     if (currentUser != null) {
//       // User is logged in, now get their profile from shared preferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       String? profileJson = prefs.getString('profile');
//       if (profileJson != null) {
//         Map<String, dynamic> userProfile =
//         jsonDecode(profileJson) as Map<String, dynamic>;
//
//         print('The pref name is ${userProfile['name']}');
//
//         String name = userProfile['name'] ?? '';
//         String role = userProfile['role'] ?? '';
//         String uid = userProfile['uid'] ?? '';
//         String email = userProfile['email'] ?? '';
//
//         // Update the state in the authControllerProvider
//         ref.read(authControllerProvider.notifier).updateUser(
//           name: name,
//           role: role,
//           uid: uid,
//           email: email,
//         );
//
//         // After updating the state, navigate to the HomeScreen
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => HomeScreen(),
//         ));
//       } else {
//         print('A user is signed in yet going to singin screen');
//         // If profile data isn't available, navigate to SignInScreen
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => SignInScreen(),
//         ));
//       }
//     } else {
//       print('No user signed in');
//       // No user signed in, navigate to SignInScreen
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => SignInScreen(),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     double height = size.height;
//     double width = size.width;
//
//     return Scaffold(
//       backgroundColor: const Color(0XFFffffff), // You can change the background color
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             // Replace with your app's logo or image
//             Image.asset(
//               'assets/images/ichiban_logo.png', // Your image path
//               height: height * 0.3,
//             ),
//             Positioned(
//               top: height * 0.2,
//               left: width * 0.22,
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.car_repair_sharp, // Example icon
//                     size: width * .09,
//                     color: Colors.black,
//                   ),
//                   const Text(
//                     'For everything cars',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Check the current user and navigate accordingly
//     // checkCurrentUser();
//
//   }


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();


    Future.microtask(()async {
      await Future.delayed(const Duration(seconds: 3));
      ref.read(authControllerProvider.notifier).currentUser(context);
    });
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
