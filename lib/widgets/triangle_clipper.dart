import 'package:flutter/cupertino.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override

  // Path getClip(Size size) {
  //   final Path path = Path();
  //   path.moveTo(0, size.height); // Start at bottom-left corner
  //   path.lineTo(0, 0); // Move to the top-left corner
  //   path.lineTo(size.width, size.height); // Move to bottom-right corner
  //   path.close(); // Draw back to the start
  //
  //   return path;
  // }
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

