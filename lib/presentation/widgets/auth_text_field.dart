import 'package:flutter/material.dart';
import 'package:taskify/core/colors/colors.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final ValueChanged<String> onChanged;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscure = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primary),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
