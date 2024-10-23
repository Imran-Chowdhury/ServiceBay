import 'package:flutter/material.dart';



class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  String? Function(String?)? validate;

  CustomTextField({
    Key? key,
    required this.controller, // Required to pass a controller
    required this.labelText,
    required this.validate// Required to pass the label text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validate,
    );
  }
}

