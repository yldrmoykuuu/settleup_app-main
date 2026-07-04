import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final String? errorText;
  final TextEditingController controller;
  final IconData? icon;
  final bool isPassword;
  final TextInputType? keyboardType;

  const InputTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.labelText,
    this.errorText,
    this.icon,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscure,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorText: widget.errorText,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
