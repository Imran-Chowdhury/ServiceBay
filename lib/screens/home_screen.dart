import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_bay/screens/mechanic_home_screen.dart';
import 'package:service_bay/widgets/custom_tile.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../widgets/triangle_clipper.dart';

import 'booking_screen.dart';
import 'calendar_screen.dart';







class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // HomeScreen({this.name,this.role,this.uid});
  // String? name;
  // String? role;
  // String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width = size.width;

    AuthState authState = ref.watch(authControllerProvider);

    return authState.role=='admin' ? Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {  },),
      backgroundColor: const Color(0xFFffffff),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFffffff),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut(context);

            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (stateController.role == 'mechanic')
              //   Align(
              //     alignment: Alignment.topCenter,
              //     child: Image.asset(
              //       'assets/images/mechanic.png',
              //       height: height * 0.4,
              //       width: width * 0.8,
              //     ),
              //   )
              // else if (stateController.role == 'admin')
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/admin.png',
                    height: height * 0.4,
                    width: width * 0.8,
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  'Hello ${authState.name?? 'User'}',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  ' ${authState.role?? 'Role'}'.toUpperCase(),
                //   // stateController.role!.toUpperCase() ,
                  style: const TextStyle(
                    fontSize: 18,
                     fontWeight: FontWeight.bold,
                     color: Colors.grey,
                   ),
                 ),
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            right: 0,
            // left: 0,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                color: Colors.red, // Change the color of the triangle
                height: height * 0.5, // Adjust triangle height
                width: width *0.9,   // Adjust triangle width
              ),
            ),
          ),


          Positioned(
            top: height*.55,
              // left: width*.1,
            right: width*.1,

              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingScreen()),
                  );
                },
                child: const CustomTile(
                  icon: Icon(Icons.add,
                    color: Colors.black,
                    size: 50,
                  ),
                  // color: Color(0xFFff8f81),
                  color: Color(0xFFF5F5DC),//beige
                  tileName: 'Reserve',
                ),
              ),
          ),

          Positioned(
              top: height*.7,
              // right: width*.2,
              left: width*.2,
              child: GestureDetector(


                onTap: (){
                  // if(authState.role=='mechanic') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CalendarScreen(
                            authState.uid!,
                            role: authState.role,
                          ),
                    ),
                  );
                },
                child: const CustomTile(
                    icon: Icon(Icons.calendar_today,
                      size: 50,
                      color: Colors.black,),
                  color: Color(0xFFD3D3D3), //light grey
                  // color: Color(0xFFF5F5DC),//beige
                  // color: Color(0xFF7d85b3),
                  // color: Colors.white,


                  tileName: 'Bookings',

                ),
              ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Align to the center
              children: [
                Text(
                  'Powered by Ichiban Auto Limited ',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '®', // Registered Trademark symbol
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.superscripts()], // Optional: Make the ® sign superscript
                  ),
                ),

              ],
            ),
          )


        ],
      ),
    ):const MechanicHomeScreen();
  }
}



