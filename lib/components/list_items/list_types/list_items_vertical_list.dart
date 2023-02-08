part of '../list_items_parent.dart';

class ListItemsVerticalList extends StatelessWidget {
  final List<Item> items;
  final ScrollPhysics scrollPhysics;
  final BoxFit boxFit;
  final Widget? notFoundPlaceholder;

  const ListItemsVerticalList(
      {super.key,
      this.boxFit = BoxFit.cover,
      this.notFoundPlaceholder,
      required this.scrollPhysics,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        physics: scrollPhysics,
        itemBuilder: (_, index) => Column(
              children: [
                itemSelector(items.elementAt(index), context),

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
        child: Divider(height: 2, thickness: 2, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2)),
      );
    }
    return const SizedBox();
  }

  Widget itemSelector(final Item item, BuildContext context) {
    final itemHeight = context.read<CollectionBloc>().state.verticalListPosterHeight;
    switch (item.type) {
      case ItemType.Audio:
      case ItemType.MusicAlbum:
        // Music items will fit automatically
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: itemHeight, minHeight: 50), child: MusicItem(item: item));
      case ItemType.Movie:
      case ItemType.Episode:
        // Episode items need height to avoid unbounded height
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: itemHeight, minHeight: 50),
            child: EpisodeItem(item: item, boxFit: boxFit, notFoundPlaceholder: notFoundPlaceholder));
      default:
        // Episode items need height to avoid unbounded height
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: itemHeight, minHeight: 50),
            child: EpisodeItem(item: item, boxFit: boxFit, notFoundPlaceholder: notFoundPlaceholder));
    }
  }
}
