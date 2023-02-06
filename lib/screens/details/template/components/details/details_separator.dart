import 'package:flutter/material.dart';

class DetailsSeparator extends StatelessWidget {
  const DetailsSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Text('|', style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
