      import 'package:flutter/material.dart';

      final class NomadButton extends StatelessWidget {
        const NomadButton({super.key, required this.label, required this.onPressed});
        final String label;
final VoidCallback? onPressed;

@override
Widget build(BuildContext context) => ElevatedButton(onPressed: onPressed, child: Text(label));
      }
