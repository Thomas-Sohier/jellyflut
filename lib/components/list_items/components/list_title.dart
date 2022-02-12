part of '../list_items_parent.dart';

class ListTitle extends StatelessWidget {
  final Widget child;
  final Item item;
  final bool showTitle;

  const ListTitle(
      {Key? key,
      required this.child,
      required this.item,
      this.showTitle = false})
      : super(key: key);

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
                item.type.getValue().toLowerCase().capitalize(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(height: 12),
            child
          ]);
    }
    return child;
  }
}
