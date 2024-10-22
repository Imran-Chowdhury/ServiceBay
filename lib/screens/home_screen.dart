import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'admin_calendar_screen.dart';
import 'booking_screen.dart';
import 'mechanic_job_screen.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthState stateController = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('${stateController.name?? 'User'} (${stateController.role ?? 'unknown'})'),
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
      body: Column(
        children: [
          Center(
            child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingScreen()),
                  );
                },
                child: const Text('Tap to add bookins!')),
          ),
          Center(
            child: GestureDetector(
                onTap: (){
                 if(stateController.role=='mechanic') {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) =>
                           MechanicCalendarScreen(
                             mechanicUid: stateController.uid!,),),
                   );
                 }else{
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) =>
                       AdminCalendarScreen(),),
                   );
                 }
                },
                child: const Text('Tap to see calendar view!')),
          ),
        ],
      ),
    );
  }
}
