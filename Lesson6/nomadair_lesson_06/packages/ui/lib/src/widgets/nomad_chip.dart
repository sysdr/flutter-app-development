      import 'package:flutter/material.dart';

      final class NomadChip extends StatelessWidget {
        const NomadChip({super.key, required this.label, required this.onTap});
        final String label;
final VoidCallback onTap;

@override
Widget build(BuildContext context) => ActionChip(label: Text(label), onPressed: onTap);
      }
