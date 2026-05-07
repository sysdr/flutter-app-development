import 'package:flutter/material.dart';

class NomadTextField extends StatelessWidget {
  const NomadTextField({
    super.key,
    this.label = '',
    this.hint,
    this.controller,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
