part of '../details_widgets.dart';

class PeoplesDetailsWidget extends StatelessWidget {
  final Item item;
  const PeoplesDetailsWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (!item.hasPeople()) return SizedBox();
    return Column(
      children: [
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('item_cast'.tr(args: [item.name]),
              style: Theme.of(context).textTheme.headline5),
        ),
        const SizedBox(height: 8),
        SizedBox(height: 230, child: PeoplesList(item.people)),
      ],
    );
  }
}
