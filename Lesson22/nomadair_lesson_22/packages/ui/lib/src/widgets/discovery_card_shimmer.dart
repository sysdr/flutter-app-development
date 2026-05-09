import 'package:flutter/material.dart';

class DiscoveryCardShimmer extends StatelessWidget {
  const DiscoveryCardShimmer({
    super.key,
    this.animation,
  });

  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 160,
        width: double.infinity,
      ),
    );
  }
}
