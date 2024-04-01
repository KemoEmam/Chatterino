import 'package:flutter/material.dart';

class CustomTextFormFeld extends StatelessWidget {
  const CustomTextFormFeld(
      {super.key, this.hintText, this.onChanged, this.obscureText = false});
  final String? hintText;
  final bool? obscureText;
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: (data) {
        if (data!.isEmpty) {
          return 'Field is required';
        } else {
          return null;
        }
      },
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.white)),
      ),
    );
  }
}
