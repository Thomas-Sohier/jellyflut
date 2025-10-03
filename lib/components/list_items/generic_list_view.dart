import 'package:flutter/material.dart';

enum ListLayout { horizontal, vertical, grid }

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

class GenericListView<T> extends StatelessWidget {
  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final ListLayout layout;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final EdgeInsets padding;
  final double? itemExtent;

  // Grid specific properties
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  const GenericListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.layout = ListLayout.grid,
    this.controller,
    this.physics,
    this.padding = EdgeInsets.zero,
    this.itemExtent,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    switch (layout) {
      case ListLayout.horizontal:
        return _buildHorizontalList();
      case ListLayout.vertical:
        return _buildVerticalList();
      case ListLayout.grid:
        return _buildGrid();
    }
  }

  Widget _buildHorizontalList() {
    return ListView.builder(
      controller: controller,
      physics: physics,
      padding: padding,
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemExtent: itemExtent,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );
  }

  Widget _buildVerticalList() {
    return ListView.builder(
      controller: controller,
      physics: physics,
      padding: padding,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      controller: controller,
      physics: physics,
      padding: padding,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );
  }
}
