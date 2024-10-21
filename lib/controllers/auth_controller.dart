import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

class AuthState {
  // remove user and manually write name, role and email
  final String? name;
  final String? role;
  final String? email;
  // final String? uid;
  final bool isLoading;

  // AuthState({this.user, this.isLoading = false});
  AuthState({this.name, this.email, this.role,  this.isLoading = false});

  // AuthState copyWith({User? user, bool? isLoading}) {
  AuthState copyWith({String? name, String? role, String? email, bool? isLoading}) {
    return AuthState(
      // user: user ?? this.user,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      // uid: uid?? this.uid,
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
        // await fireStore.collection('users').doc(user.uid).set({
        //   'name': name,
        //   'email': email,
        //   'role': role,
        // });
        // state = state.copyWith(user: user, isLoading: false);

        if (role == 'mechanic') {
          // Save user data in the `users-mechanic` collection
          await fireStore.collection('mechanic').doc(user.uid).set({
            'name': name,
            'email': email,
            'role': role,
          });
        } else if (role == 'admin') {
          // Save user data in the `users-admin` collection
          await fireStore.collection('admin').doc(user.uid).set({
            'name': name,
            'email': email,
            'role': role,
          });
        }
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);
    String currentUserName = '';
    String currentUserRole = '';
    String currentUserEmail = '';
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print(userCredential.user?.uid);
      final currentUser = auth.currentUser;
      // print(currentUser?.uid);

      DocumentSnapshot adminDoc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(currentUser?.uid)
          .get();

      if(adminDoc.exists){
        currentUserName = adminDoc['name'];
        currentUserRole = adminDoc['role'];
        currentUserEmail = adminDoc['email'];
      }else{
        DocumentSnapshot mechaDoc = await FirebaseFirestore.instance.collection('mechanic')
            .doc(currentUser?.uid)
            .get();


        if (mechaDoc.exists) {
          // Get additional user info like name and role
          currentUserName = mechaDoc['name'];
          currentUserRole = mechaDoc['role'];
          currentUserEmail = mechaDoc['email'];
        }
      }


      // state = state.copyWith(user: currentUser, isLoading: false);
      state = state.copyWith(name: currentUserName, email: currentUserEmail, role: currentUserRole, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    // state = state.copyWith(user: null);
    state = state.copyWith(name: null, email: null, role: null);
  }
}
