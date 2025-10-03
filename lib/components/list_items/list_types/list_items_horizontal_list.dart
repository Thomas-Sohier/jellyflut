part of '../list_items_parent.dart';

class _ListItemsHorizontalList extends StatelessWidget {
  final List<Item> items;
  final ScrollController controller;

  const _ListItemsHorizontalList({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    final itemHeight = context.select((CollectionBloc bloc) => bloc.horizontalListPosterHeight);
    final physics = context.select((CollectionBloc bloc) => bloc.physics);
    const itemAspectRatio = 2 / 3;
    const itemSpacing = 8.0;
    final hasFixedExtent = itemHeight < RefinedBreakpoints().desktopExtraLarge;
    if (hasFixedExtent) {
      final itemWidth = itemHeight * itemAspectRatio;
      return SizedBox(
        height: itemHeight + 40,
        child: ListView.builder(
          controller: controller,
          physics: physics,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemExtent: itemWidth + itemSpacing,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: itemSpacing),
              child: ItemPoster(items[index]),
            );
          },
        ),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;

          if (!availableHeight.isFinite || availableHeight <= 40) {
            return const SizedBox.shrink();
          }

          final posterHeight = availableHeight - 40;
          final posterWidth = posterHeight * itemAspectRatio;

          return ListView.builder(
            controller: controller,
            physics: physics,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: itemSpacing),
                child: SizedBox(width: posterWidth, child: ItemPoster(items[index])),
              );
            },
          );
        },
      );
    }
  }
}
