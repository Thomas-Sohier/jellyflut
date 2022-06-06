import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';

class ListItemsSortFieldButton extends StatefulWidget {
  const ListItemsSortFieldButton({super.key});

  @override
  State<ListItemsSortFieldButton> createState() =>
      _ListItemsSortFieldButtonState();
}

class _ListItemsSortFieldButtonState extends State<ListItemsSortFieldButton> {
  late final GlobalKey<PopupMenuButtonState<FieldsEnum>> popupButtonKey;
  late FieldsEnum currentValue;

  @override
  void initState() {
    popupButtonKey = GlobalKey();
    currentValue = FieldsEnum.AIRDAYS;
    super.initState();
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
            initialValue: currentValue,
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
    FieldsEnum.getSortable()
        .forEach((field) => fieldItems.add(CheckedPopupMenuItem(
              value: field,
              checked: currentValue == field,
              child: Text(field.fullName),
            )));
    return fieldItems;
  }

  void sortByField(final BuildContext context, final FieldsEnum? fieldEnum) {
    if (fieldEnum == null) return;

    final collectionBloc = BlocProvider.of<CollectionBloc>(context);
    collectionBloc.add(SortByField(fieldEnum: fieldEnum));
  }
}
