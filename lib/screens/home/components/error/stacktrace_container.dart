import 'package:flutter/material.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:rxdart/rxdart.dart';

class StacktraceContainer extends StatelessWidget {
  final BehaviorSubject<bool> togglestream;
  final String message;
  StacktraceContainer(
      {Key? key, required this.togglestream, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: togglestream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return errorContainer(context);
          }
          return const SizedBox();
        });
  }

  Widget errorContainer(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorUtil.darken(Theme.of(context).backgroundColor, 0.05),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      constraints: BoxConstraints(maxHeight: 400),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
