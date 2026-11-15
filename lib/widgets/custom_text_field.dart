import 'package:flutter/material.dart';

import '../services/app_theme.dart';

/// Campo de texto reutilizable con etiqueta, validación y modo contraseña.
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _visible;

  @override
  void initState() {
    super.initState();
    _visible = !widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText && !_visible,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: const TextStyle(
        color: AppColors.navy,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: AppColors.navy.withValues(alpha: 0.75)),
        prefixIcon: Icon(widget.icon),
        prefixIconColor: AppColors.navy.withValues(alpha: 0.7),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _visible ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
                tooltip: _visible ? 'Ocultar contraseña' : 'Mostrar contraseña',
                onPressed: () => setState(() => _visible = !_visible),
              )
            : null,
      ),
    );
  }
}
