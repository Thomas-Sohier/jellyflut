part of '../details_widgets.dart';

class PeoplesDetailsWidget extends StatelessWidget {
  final Item item;
  final EdgeInsets padding;
  const PeoplesDetailsWidget(
      {super.key,
      required this.item,
      this.padding = const EdgeInsets.only(left: 12)});

  @override
  Widget build(BuildContext context) {
    if (!item.hasPeople()) return SizedBox();
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
            padding: padding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('item_cast'.tr(args: [item.name]),
                  style: Theme.of(context).textTheme.headline5),
            )),
        const SizedBox(height: 8),
        SizedBox(
            height: 230, child: PeoplesList(item.people, padding: padding)),
      ],
    );
  }
}
