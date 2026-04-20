      import 'package:flutter/material.dart';

      final class NomadCard extends StatelessWidget {
        const NomadCard({super.key, required this.child});
        final Widget child;

@override
Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(12), child: child));
      }
