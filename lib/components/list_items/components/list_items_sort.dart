part of '../list_items_parent.dart';

class ListItemsSort extends StatelessWidget {
  final Widget child;
  final List<ListType> listTypes;

  const ListItemsSort(
      {Key? key, this.child = const SizedBox(), required this.listTypes})
      : super(key: key);

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
                    onPressed: () => getNextListType(context)),
                IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () => sortByDate(context)),
                IconButton(
                    icon: Icon(Icons.sort_by_alpha),
                    onPressed: () => sortByName(context)),
              ]),
          child
        ]);
  }

  void sortByDate(final BuildContext context) {
    final collectionBloc = BlocProvider.of<CollectionBloc>(context);
    collectionBloc.add(SortByDate());
  }

  void sortByName(final BuildContext context) {
    final collectionBloc = BlocProvider.of<CollectionBloc>(context);
    collectionBloc.add(SortByName());
  }

  void getNextListType(final BuildContext context) async {
    final collectionBloc = BlocProvider.of<CollectionBloc>(context);
    final currentListType = collectionBloc.listType.stream.value;
    final nextIndex = listTypes.indexOf(currentListType) == listTypes.length - 1
        ? 0
        : listTypes.indexOf(currentListType) + 1;
    collectionBloc.listType.add(listTypes.elementAt(nextIndex));
  }
}
