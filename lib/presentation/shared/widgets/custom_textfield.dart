import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final controller;
  final hintText;
  final bool obscureText;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.green.shade700.withOpacity(0.7),
        style: TextStyle(
          color: Colors.green.shade700,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.green.shade900),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.green.shade700.withOpacity(0.5)),
        ),
      ),
    );
  }
}
