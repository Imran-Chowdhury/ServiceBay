import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_bay/widgets/custom_tile.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'admin_calendar_screen.dart';
import 'booking_screen.dart';
import 'mechanic_job_screen.dart';






import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width = size.width;

    AuthState stateController = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFffffff),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              Navigator.pushReplacementNamed(context, '/signIn');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stateController.role == 'mechanic')
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/mechanic.png',
                    height: height * 0.4,
                    width: width * 0.8,
                  ),
                )
              else if (stateController.role == 'admin')
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
                  'Hello ${stateController.name!}',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  stateController.role!.toUpperCase(),
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
            top: height*.5,
              left: width*.1,
              child: CustomTile()),


          // Triangle-shaped container in the bottom-right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                color: Colors.red, // Change the color of the triangle
                height: height * 0.5, // Adjust triangle height
                width: width * 0.7,   // Adjust triangle width
              ),
            ),
          ),

          Positioned(
              top: height*.5,
              right: width*.1,
              child: CustomTile()),


        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height); // Start at bottom-left corner
    path.lineTo(size.width, size.height); // Bottom-right corner
    path.lineTo(size.width, 0); // Top-right corner
    path.close(); // Draw back to the start

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}




// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//
//     Size size = MediaQuery.sizeOf(context);
//     double height = size.height;
//     double width  = size.width;
//     AuthState stateController = ref.watch(authControllerProvider);
//     return Scaffold(
//       backgroundColor: Color(0xFFffffff),
//       appBar: AppBar(
//           automaticallyImplyLeading: false,
//         backgroundColor: Color(0xFFffffff),
//         // title: Text('${stateController.name?? 'User'} (${stateController.role ?? 'unknown'})'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await ref.read(authControllerProvider.notifier).signOut();
//               Navigator.pushReplacementNamed(context, '/signIn');
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           if (stateController.role == 'mechanic')
//             Align(
//               alignment: Alignment.topCenter,
//               child: Image.asset(
//                 'assets/images/mechanic.png', // Path to your mechanic image
//                 height: height * 0.4, // Adjust height as needed
//                 width: width * 0.8,   // Adjust width as needed
//               ),
//             )
//           else if (stateController.role == 'admin')
//             Align(
//               alignment: Alignment.topCenter,
//               child: Image.asset(
//                 'assets/images/admin.png', // Path to your admin image
//                 height: height * 0.4, // Adjust height as needed
//                 width: width * 0.8,   // Adjust width as needed
//               ),
//             ),
//
//
//           Padding(
//             padding: EdgeInsets.only(left: width *0.03),
//               child: Text('Hello ${stateController.name!}',
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//           ),
//
//           Padding(
//             padding: EdgeInsets.only(left: width *0.03),
//             child: Text(
//               stateController.role!.toUpperCase(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey
//               ),
//             ),
//           ),
//
//
//
//
//
//
//           // Center(
//           //   child: GestureDetector(
//           //       onTap: (){
//           //         Navigator.push(
//           //           context,
//           //           MaterialPageRoute(builder: (context) => const BookingScreen()),
//           //         );
//           //       },
//           //       child: const Text('Tap to add bookins!')),
//           // ),
//           // Center(
//           //   child: GestureDetector(
//           //       onTap: (){
//           //        if(stateController.role=='mechanic') {
//           //          Navigator.push(
//           //            context,
//           //            MaterialPageRoute(
//           //              builder: (context) =>
//           //                  MechanicCalendarScreen(
//           //                    mechanicUid: stateController.uid!,),),
//           //          );
//           //        }else{
//           //          Navigator.push(
//           //            context,
//           //            MaterialPageRoute(
//           //              builder: (context) =>
//           //              AdminCalendarScreen(),),
//           //          );
//           //        }
//           //       },
//           //       child: const Text('Tap to see calendar view!')),
//           // ),
//         ],
//       ),
//     );
//   }
// }
