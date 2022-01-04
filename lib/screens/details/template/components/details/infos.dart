part of '../details_widgets.dart';

class InfosDetailsWidget extends StatelessWidget {
  final Item item;

  const InfosDetailsWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.productionYear != null)
            Text(
              item.productionYear.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          if (item.productionYear != null) const DetailsSeparator(),
          if (item.getDuration() != 0) ItemDuration(item: item)
        ],
      ),
    );
  }
}
