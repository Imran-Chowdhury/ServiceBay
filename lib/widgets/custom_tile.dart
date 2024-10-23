import 'package:flutter/material.dart';


class CustomTile extends StatelessWidget {
  final Color color;
  final String tileName;
  final Icon icon;

  const CustomTile({
    super.key,
    required this.icon,
    required this.color,
    required this.tileName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0, // Set the elevation
      borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
      child: Container(
        height: 100, // Fixed height
        width: 200,  // Set the width larger than the height
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding on the sides
        decoration: BoxDecoration(
          color: color, // Background color for the tile
          borderRadius: BorderRadius.circular(20.0), // Same as Material's borderRadius
        ),
        child: Row(  // Place icon and text in a row
          children: [
            // Icon aligned to the left
            icon,

            const SizedBox(width: 16), // Add space between icon and text

            // Text aligned next to the icon
            Expanded(
              child: Text(
                tileName, // Use the tile name that is passed as a parameter
                style: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomTile extends StatelessWidget {
//   // The fields should be final as they are immutable in StatelessWidget
//   final Color color;
//   final String tileName;
//   final Icon icon;
//
//   // Add required parameters properly with a comma at the end
//   const CustomTile({super.key,
//     required this.icon,
//     required this.color,
//     required this.tileName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 8.0, // Set the elevation
//       borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
//       // shadowColor: Colors.black.withOpacity(0.5), // Optional: Customize the shadow color
//       child: Container(
//         height: 100,
//         width: 200,
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: color, // Background color for the tile
//           borderRadius: BorderRadius.circular(20.0), // Same as Material's borderRadius
//         ),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             icon, // Use the icon that is passed as a parameter
//
//             Center(
//               child: Text(
//                 tileName, // Use the tile name that is passed as a parameter
//                 style: const TextStyle(
//                   color: Colors.black45,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
