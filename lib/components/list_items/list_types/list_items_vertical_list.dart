part of '../list_items_parent.dart';

class ListItemsVerticalList extends StatelessWidget {
  final List<Item> items;
  final ScrollPhysics scrollPhysics;
  final ScrollController scrollController;

  const ListItemsVerticalList(
      {Key? key,
      required this.scrollPhysics,
      required this.items,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    return ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        controller: scrollController,
        physics: scrollPhysics,
        itemBuilder: (context, index) => Column(
              children: [
                itemSelector(items.elementAt(index)),

                // If item is not last and screen is mobile then we show a
                // divider for better readability
                if (deviceType == DeviceScreenType.mobile &&
                    index + 1 < items.length)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 4, bottom: 4),
                    child: Divider(
                        height: 2,
                        thickness: 2,
                        color: Theme.of(context).primaryColor.withOpacity(0.2)),
                  )
              ],
            ));
  }

  Widget itemSelector(final Item item) {
    switch (item.type) {
      case ItemType.AUDIO:
      case ItemType.MUSICALBUM:
        // Music items will fit automatically
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: listHeight, minHeight: 50),
            child: MusicItem(item: item));
      case ItemType.MOVIE:
      case ItemType.EPISODE:
        // Episode items need height to avoid unbounded height
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: listHeight, minHeight: 50),
            child: EpisodeItem(item: item));
      default:
        // Episode items need height to avoid unbounded height
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: listHeight, minHeight: 50),
            child: EpisodeItem(item: item));
    }
  }
}
