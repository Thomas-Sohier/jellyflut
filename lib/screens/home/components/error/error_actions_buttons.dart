import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ErrorActionsbuttons extends StatelessWidget {
  final BehaviorSubject<bool> togglestream;
  final void Function() reloadFunction;
  const ErrorActionsbuttons(
      {Key? key, required this.togglestream, required this.reloadFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OutlinedButton(
            onPressed: () => reloadFunction(),
            child: Icon(Icons.replay_outlined)),
        const SizedBox(width: 12),
        StreamBuilder<bool>(
            stream: togglestream,
            builder: (context, snapshot) {
              if (snapshot.data ?? false) {
                return OutlinedButton(
                    onPressed: () => togglestream.add(false),
                    child: Text('Hide error message'));
              } else {
                return OutlinedButton(
                    onPressed: () => togglestream.add(true),
                    child: Text('Show error message'));
              }
            }),
      ],
    );
  }
}
