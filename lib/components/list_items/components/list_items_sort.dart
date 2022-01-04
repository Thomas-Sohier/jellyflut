part of '../list_items_parent.dart';

class ListItemsSort extends StatelessWidget {
  final Widget child;
  const ListItemsSort({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.grid_view),
                  onPressed: () {
                    getNextListType();
                  },
                )
              ]),
          Expanded(child: child)
        ]);
  }

  void getNextListType() {
    // final nextIndex = listTypes.indexOf(currentListType) == listTypes.length - 1
    //     ? 0
    //     : listTypes.indexOf(currentListType) + 1;
    // return currentListType = listTypes.elementAt(nextIndex);
  }
}
