import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

class AuthState {
  final User? user;
  final bool isLoading;

  AuthState({this.user, this.isLoading = false});

  AuthState copyWith({User? user, bool? isLoading}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
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
        await fireStore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': role,
        });
        state = state.copyWith(user: user, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      // state = state.copyWith(user: userCredential.user, isLoading: false);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    state = state.copyWith(user: null);
  }
}
