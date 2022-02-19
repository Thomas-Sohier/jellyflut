part of '../list_items_parent.dart';

class ListItemsVerticalList extends StatelessWidget {
  final List<Item> items;
  final ScrollPhysics scrollPhysics;
  final ScrollController scrollController;
  final double verticalListPosterHeight;
  final BoxFit boxFit;

  const ListItemsVerticalList(
      {Key? key,
      this.boxFit = BoxFit.cover,
      required this.scrollPhysics,
      required this.items,
      required this.verticalListPosterHeight,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        controller: scrollController,
        physics: scrollPhysics,
        itemBuilder: (context, index) => Column(
              children: [
                itemSelector(items.elementAt(index)),

                // If item is not last and screen is mobile then we show a
                // divider for better readability
                dividerBuilder(context, index)
              ],
            ));
  }

  Widget dividerBuilder(BuildContext context, int index) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    if (deviceType == DeviceScreenType.mobile && index + 1 < items.length) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
        child: Divider(
            height: 2,
            thickness: 2,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2)),
      );
    }
    return const SizedBox();
  }

  Widget itemSelector(final Item item) {
    switch (item.type) {
      case ItemType.AUDIO:
      case ItemType.MUSICALBUM:
        // Music items will fit automatically
        return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: verticalListPosterHeight, minHeight: 50),
            child: MusicItem(item: item));
      case ItemType.MOVIE:
      case ItemType.EPISODE:
        // Episode items need height to avoid unbounded height
        return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: verticalListPosterHeight, minHeight: 50),
            child: EpisodeItem(item: item, boxFit: boxFit));
      default:
        // Episode items need height to avoid unbounded height
        return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: verticalListPosterHeight, minHeight: 50),
            child: EpisodeItem(item: item, boxFit: boxFit));
    }
  }
}
