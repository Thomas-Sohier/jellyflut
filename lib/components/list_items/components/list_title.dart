part of '../list_items_parent.dart';

class ListTitle extends StatelessWidget {
  final Widget child;
  final Item item;
  final bool showTitle;

  const ListTitle({super.key, required this.child, required this.item, this.showTitle = false});

  @override
  Widget build(BuildContext context) {
    if (showTitle) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                item.type.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: child)
          ]);
    }
    return child;
  }
}
