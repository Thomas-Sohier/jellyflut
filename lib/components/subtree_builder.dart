import 'package:flutter/widgets.dart';

/// Helper class to only build parent which can change while preserving subtree
/// Optimize loading time with huge subtree (such as DetailsPage)
class SubtreeBuilder extends StatelessWidget {
  @override
  const SubtreeBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
