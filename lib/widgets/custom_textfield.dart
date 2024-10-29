import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validate;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool obscureText;
  final Widget? obscureIcon; // Optional obscure icon

  CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.validate,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.obscureIcon, // Optional obscure icon parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: obscureIcon, // Show obscure icon if provided
      ),
      validator: validate,
      onTap: onTap,
      readOnly: readOnly,
    );
  }
}

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final String? Function(String?)? validate;
//   final VoidCallback? onTap; // Optional onTap callback
//   final bool readOnly; // Optional readOnly parameter
//   final bool obscureText;
//
//   CustomTextField({
//     Key? key,
//     required this.controller, // Required to pass a controller
//     required this.labelText,  // Required to pass the label text
//     required this.validate,   // Required to pass the validator
//     this.onTap,               // Optional onTap
//     this.readOnly = false,
//     this.obscureText = false,// Optional readOnly (default: false)
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//     obscureText: obscureText,
//       controller: controller,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         filled: true,
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//       validator: validate,
//       onTap: onTap,           // Assign the onTap callback if provided
//       readOnly: readOnly,     // Set readOnly based on the parameter
//     );
//   }
// }
//
