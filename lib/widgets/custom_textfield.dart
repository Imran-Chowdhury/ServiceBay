import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validate;
  final VoidCallback? onTap; // Optional onTap callback
  final bool readOnly; // Optional readOnly parameter

  CustomTextField({
    Key? key,
    required this.controller, // Required to pass a controller
    required this.labelText,  // Required to pass the label text
    required this.validate,   // Required to pass the validator
    this.onTap,               // Optional onTap
    this.readOnly = false,     // Optional readOnly (default: false)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validate,
      onTap: onTap,           // Assign the onTap callback if provided
      readOnly: readOnly,     // Set readOnly based on the parameter
    );
  }
}
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//
//   String? Function(String?)? validate;
//
//   CustomTextField({
//     Key? key,
//     required this.controller, // Required to pass a controller
//     required this.labelText,
//     required this.validate// Required to pass the label text
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//       validator: validate,
//     );
//   }
// }

