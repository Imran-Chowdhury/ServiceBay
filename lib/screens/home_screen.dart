import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthState stateController = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('${stateController.user?.displayName ?? 'User'} (${stateController.user?.email ?? 'unknown'})'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              Navigator.pushReplacementNamed(context, '/signIn');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to Home!'),
      ),
    );
  }
}
