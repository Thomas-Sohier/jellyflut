part of '../details_widgets.dart';

class TitleDetailsWidget extends StatelessWidget {
  final String title;
  const TitleDetailsWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Align(
      alignment: Alignment.centerLeft,
      child: SelectableText(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.headline4,
      ),
    ));
  }
}
