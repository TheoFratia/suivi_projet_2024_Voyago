import 'package:flutter/material.dart';

Widget buildTextField(
    String labelText, {
      bool obscureText = false,
      required void Function(String) onChanged,
    }) {
  return TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    obscureText: obscureText,
  );
}
