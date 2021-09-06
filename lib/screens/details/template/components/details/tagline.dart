part of '../details_widgets.dart';

class TaglineDetailsWidget extends StatelessWidget {
  final Item item;
  const TaglineDetailsWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.taglines == null || item.taglines!.isEmpty) return SizedBox();
    return Text(
      '“ ${item.taglines!.first} „',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headline4!
          .copyWith(fontStyle: FontStyle.italic)
          .copyWith(fontFamily: 'Quicksand'),
    );
  }
}
