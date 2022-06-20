import 'package:flutter/material.dart';

class DetailsBackground extends StatelessWidget {
  const DetailsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = const Duration(milliseconds: 500);

    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: duration,
      decoration: BoxDecoration(
          color: Colors.transparent.withOpacity(0.6),
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
              colorScheme.tertiary
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
    );
  }
}
