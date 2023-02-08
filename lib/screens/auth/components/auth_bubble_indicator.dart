import 'package:flutter/material.dart';

class AuthBubbleIndicator extends StatelessWidget {
  final String value;

  const AuthBubbleIndicator({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 300),
        height: 60,
        margin: EdgeInsets.only(left: 24, right: 24),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.all(Radius.circular(80.0))),
        child: Stack(alignment: Alignment.center, children: [
          Positioned.fill(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.dns, color: Theme.of(context).colorScheme.onPrimary))),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 18),
                  )))
        ]));
  }
}
