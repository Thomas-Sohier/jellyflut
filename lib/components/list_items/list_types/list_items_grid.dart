part of '../list_items_parent.dart';

class _ListItemsGrid extends StatelessWidget {
  final List<Item> items;
  final ScrollController controller;

  const _ListItemsGrid({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CollectionBloc>();
    final itemHeight = bloc.gridPosterHeight;
    final itemAspectRatio = items.isEmpty ? 2 / 3 : items.first.getPrimaryAspectRatio(showParent: true);

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / (itemHeight * itemAspectRatio)).round().clamp(1, 10);
        return GridView.builder(
          controller: controller,
          physics: bloc.physics,
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: itemAspectRatio / (1 + (40 / itemHeight)), // ratio with label height
          ),
          itemBuilder: (context, index) => ItemPoster(items[index]),
        );
      },
    );
  }
}
