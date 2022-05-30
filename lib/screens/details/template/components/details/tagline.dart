part of '../details_widgets.dart';

class TaglineDetailsWidget extends StatelessWidget {
  final Item item;
  const TaglineDetailsWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.taglines.isEmpty) return SizedBox();
    return SelectableText(
      '“ ${item.taglines.first} „',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontStyle: FontStyle.italic)
          .copyWith(fontFamily: 'Quicksand'),
    );
  }
}
