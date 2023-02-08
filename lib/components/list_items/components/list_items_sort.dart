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
              onPressed: () => context.read<CollectionBloc>().add(ListTypeChangeRequested())),
          OutlinedButtonSelector(
              padding: EdgeInsets.all(8),
              shape: CircleBorder(),
              child: Icon(
                Icons.date_range_outlined,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => context.read<CollectionBloc>().add(SortByField(fieldEnum: FieldsEnum.DATECREATED))),
          OutlinedButtonSelector(
              padding: EdgeInsets.all(8),
              shape: CircleBorder(),
              child: Icon(
                CommunityMaterialIcons.alphabetical,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => context.read<CollectionBloc>().add(SortByField(fieldEnum: FieldsEnum.NAME))),
          ListItemsSortFieldButton()
        ]),
      ),
      child
    ]);
  }
}
