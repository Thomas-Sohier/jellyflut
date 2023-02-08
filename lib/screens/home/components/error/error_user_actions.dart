import 'package:flutter/cupertino.dart';
import 'package:jellyflut/screens/home/components/error/error_actions_buttons.dart';
import 'package:rxdart/rxdart.dart';

import 'stacktrace_container.dart';

class ErrorUserActions extends StatefulWidget {
  final void Function() reloadFunction;
  final String errorMessage;
  ErrorUserActions({super.key, required this.reloadFunction, required this.errorMessage});

  @override
  State<ErrorUserActions> createState() => _ErrorUserActionsState();
}

class _ErrorUserActionsState extends State<ErrorUserActions> {
  late final BehaviorSubject<bool> _toggleContainerMessage;

  @override
  void initState() {
    super.initState();
    _toggleContainerMessage = BehaviorSubject<bool>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ErrorActionsbuttons(togglestream: _toggleContainerMessage, reloadFunction: widget.reloadFunction),
        const SizedBox(height: 12),
        StacktraceContainer(togglestream: _toggleContainerMessage, message: widget.errorMessage)
      ],
    );
  }
}
