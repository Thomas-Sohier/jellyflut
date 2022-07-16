import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/screens/form/fields/fields_enum.dart';

class ListItemsSortFieldButton extends StatefulWidget {
  const ListItemsSortFieldButton({super.key});

  @override
  State<ListItemsSortFieldButton> createState() => _ListItemsSortFieldButtonState();
}

class _ListItemsSortFieldButtonState extends State<ListItemsSortFieldButton> {
  late final GlobalKey<PopupMenuButtonState<FieldsEnum>> popupButtonKey;
  late FieldsEnum? currentValue;

  @override
  void initState() {
    popupButtonKey = GlobalKey();
    super.initState();
  }

  void listSortedValue() {
    // currentValue = collectionBloc.getCurrentSortedValue.value;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => popupButtonKey.currentState?.showButtonMenu(),
        padding: EdgeInsets.all(8),
        shape: CircleBorder(),
        child: IgnorePointer(
          child: PopupMenuButton<FieldsEnum>(
            key: popupButtonKey,
            initialValue: FieldsEnum.AIRDAYS,
            onSelected: (FieldsEnum? field) => sortByField(context, field),
            itemBuilder: (BuildContext c) => _fieldTile(c),
            child: Icon(
              CommunityMaterialIcons.dots_horizontal,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ));
  }

  List<PopupMenuEntry<FieldsEnum>> _fieldTile(BuildContext context) {
    final fieldItems = <PopupMenuEntry<FieldsEnum>>[];
    FieldsEnum.getSortable().forEach((field) => fieldItems.add(PopupMenuItem(
          value: field,
          child: ListTile(
            leading: currentValue == field ? _leadingListTile() : const SizedBox(),
            title: Text(field.fullName),
          ),
        )));
    return fieldItems;
  }

  Widget _leadingListTile() {
    // late final IconData icon;
    // final collectionBloc = context.read<CollectionBloc>();
    // if (collectionBloc.getSortOrder == SortBy.ASC) {
    //   icon = Icons.arrow_upward;
    // } else if (collectionBloc.getSortOrder == SortBy.DESC) {
    //   icon = Icons.arrow_downward;
    // }

    return Icon(Icons.arrow_downward, color: Theme.of(context).iconTheme.color);
  }

  void sortByField(final BuildContext context, final FieldsEnum? fieldEnum) {
    if (fieldEnum == null) return;

    currentValue = fieldEnum;

    final collectionBloc = BlocProvider.of<CollectionBloc>(context);
    collectionBloc.add(SortByField(fieldEnum: fieldEnum));
  }
}
