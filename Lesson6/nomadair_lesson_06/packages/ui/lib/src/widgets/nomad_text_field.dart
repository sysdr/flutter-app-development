      import 'package:flutter/material.dart';

      final class NomadTextField extends StatelessWidget {
        const NomadTextField({super.key, required this.label, this.controller});
        final String label;
final TextEditingController? controller;

@override
Widget build(BuildContext context) => TextField(controller: controller, decoration: InputDecoration(labelText: label));
      }
