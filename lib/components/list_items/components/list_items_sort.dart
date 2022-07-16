part of '../list_items_parent.dart';

class ListItemsSort extends StatelessWidget {
  final Widget child;

  const ListItemsSort({super.key, this.child = const SizedBox()});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          OutlinedButtonSelector(
              padding: EdgeInsets.all(8),
              shape: CircleBorder(),
              child: Icon(
                Icons.grid_view,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => getNextListType(context)),
          OutlinedButtonSelector(
              padding: EdgeInsets.all(8),
              shape: CircleBorder(),
              child: Icon(
                Icons.date_range_outlined,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => sortByDate(context)),
          OutlinedButtonSelector(
              padding: EdgeInsets.all(8),
              shape: CircleBorder(),
              child: Icon(
                CommunityMaterialIcons.alphabetical,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => sortByName(context)),
          ListItemsSortFieldButton()
        ]),
      ),
      child
    ]);
  }

  void sortByDate(final BuildContext context) {
    final collectionBloc = BlocProvider.of<CollectionBloc>(context);
    collectionBloc.add(SortByField(fieldEnum: FieldsEnum.DATECREATED));
  }

  void sortByName(final BuildContext context) {
    final collectionBloc = BlocProvider.of<CollectionBloc>(context);
    collectionBloc.add(SortByField(fieldEnum: FieldsEnum.NAME));
  }

  void getNextListType(final BuildContext context) async {
    // final collectionBloc = BlocProvider.of<CollectionBloc>(context);
    // final currentListType = collectionBloc.listType.stream.value;
    // final nextIndex =
    //     ListType.values.indexOf(currentListType) == ListType.values.length - 1 ? 0 : ListType.values.indexOf(currentListType) + 1;
    // collectionBloc.listType.add(ListType.values.elementAt(nextIndex));
  }
}
