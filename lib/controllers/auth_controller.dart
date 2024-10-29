import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../screens/home_screen.dart';
import '../screens/sign_in_screen.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});



class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required BuildContext context,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateProfile(displayName: name);
      User? user = userCredential.user;


      if (user != null) {
        if (role == 'mechanic') {
          // Save user data in the `users-mechanic` collection
          await fireStore.collection('mechanic').doc(user.uid).set({
            'name': name,
            'email': email,
            'role': role,
            'uid': user.uid
          });
        } else if (role == 'admin') {
          // Save user data in the `users-admin` collection
          await fireStore.collection('admin').doc(user.uid).set({
            'name': name,
            'email': email,
            'role': role,
            'uid': user.uid
          });
        }
        state = state.copyWith(isLoading: false);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully signed up'),
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to sign up'),
      ));
      // throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signIn(String email, String password,
      BuildContext context) async {
    state = state.copyWith(isLoading: true);
    String currentUserName = '';
    String currentUserRole = '';
    String currentUserEmail = '';
    String currentUserUid = '';
    Map<String,dynamic> store = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print(userCredential.user?.uid);
     print('The uid from user cred ${ userCredential.user!.uid}');
      // final currentUser = auth.currentUser;
      // print(currentUser?.uid);

      DocumentSnapshot adminDoc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(userCredential.user?.uid)
          .get();

      if (adminDoc.exists) {
        currentUserName = adminDoc['name'];
        currentUserRole = adminDoc['role'];
        currentUserEmail = adminDoc['email'];
        currentUserUid = adminDoc['uid'];
        print(currentUserName);
        store['name'] = currentUserName;
        store['email'] = currentUserEmail;
        store['role'] = currentUserRole;
        store['uid'] = currentUserUid;


        // SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile', jsonEncode(store));
      } else {
        DocumentSnapshot mechaDoc = await FirebaseFirestore.instance.collection(
            'mechanic')
            .doc(userCredential.user?.uid)
            .get();


        if (mechaDoc.exists) {
          // Get additional user info like name and role
          currentUserName = mechaDoc['name'];
          currentUserRole = mechaDoc['role'];
          currentUserEmail = mechaDoc['email'];
          currentUserUid = mechaDoc['uid'];

          store['name'] = currentUserName;
          store['email'] = currentUserEmail;
          store['role'] = currentUserRole;
          store['uid'] = currentUserUid;

          await prefs.setString('profile', jsonEncode(store));
        }
      }
      print(currentUser);
        print(currentUserRole);

      // state = state.copyWith(user: currentUser, isLoading: false);
      state = state.copyWith(name: currentUserName,
          email: currentUserEmail,
          uid: currentUserUid,
          role: currentUserRole,
          isLoading: false);
      // Navigator.pushNamed(context, '/home');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    } catch (e) {
      state = state.copyWith(isLoading: false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Failed to sign in! Please check your email and password'),
      ));
      throw Exception(e.toString());
    }
  }
  Future<void> currentUser(BuildContext context) async {

    String currentUserName = '';
    String currentUserRole = '';
    String currentUserEmail = '';
    String currentUserUid = '';


    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Try to get the stored profile data
    String? profileJson = prefs.getString('profile');

    if (profileJson != null) {

      Map<String,dynamic> user = jsonDecode(profileJson) as Map<String, dynamic>;


      currentUserName = user['name'];
      currentUserUid  = user['uid'];
      currentUserEmail = user['email'];
      currentUserRole = user['role'];
      print(currentUser);
      print(currentUserRole);

      // state = state.copyWith(user: currentUser, isLoading: false);
      state = state.copyWith(name: currentUserName,
          email: currentUserEmail,
          uid: currentUserUid,
          role: currentUserRole,
          isLoading: false);
      Navigator.pushReplacementNamed(context, '/home');
    }else {
      // No user signed in, navigate to SignInScreen
      Navigator.pushReplacementNamed(context, '/signIn');
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (context) => SignInScreen(),
      // ));
    }


  }

  Future<void> signOut(BuildContext context) async {
    await auth.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

    state = state.copyWith(name: null, email: null, role: null);
    Navigator.pushReplacementNamed(context, '/signIn');

    // state = state.copyWith(user: null);

  }



}


