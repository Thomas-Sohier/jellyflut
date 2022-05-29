part of '../details_widgets.dart';

class OriginalTitleDetailsWidget extends StatelessWidget {
  final String? title;
  const OriginalTitleDetailsWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    if (title == null) return SizedBox();
    return Align(
        alignment: Alignment.centerLeft,
        child: SelectableText(
          title!,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline5,
        ));
  }
}
