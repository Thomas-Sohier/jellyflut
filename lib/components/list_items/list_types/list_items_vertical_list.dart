part of '../list_items_parent.dart';

class _ListItemsVerticalList extends StatelessWidget {
  final List<Item> items;
  final ScrollController controller;

  const _ListItemsVerticalList({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    final physics = context.select((CollectionBloc bloc) => bloc.physics);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ListView.builder(
        itemCount: items.length,
        controller: controller,
        physics: physics,
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) =>
            Column(children: [itemSelector(items.elementAt(index), context), dividerBuilder(context, index)]),
      ),
    );
  }

  Widget dividerBuilder(BuildContext context, int index) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    if (deviceType == DeviceScreenType.mobile && index + 1 < items.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Divider(height: 2, thickness: 2, color: Theme.of(context).colorScheme.onSurface.withAlpha(20)),
      );
    }
    return const SizedBox();
  }

  Widget itemSelector(final Item item, BuildContext context) {
    final itemHeight = context.read<CollectionBloc>().verticalListPosterHeight;
    final constraints = BoxConstraints(maxHeight: itemHeight, minHeight: 50);

    switch (item.type) {
      case ItemType.Audio:
      case ItemType.MusicAlbum:
        return ConstrainedBox(
          constraints: constraints,
          child: MusicItem(item: item),
        );
      default:
        return ConstrainedBox(
          constraints: constraints,
          child: EpisodeItem(item: item),
        );
    }
  }
}
