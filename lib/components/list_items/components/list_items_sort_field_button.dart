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

  @override
  void initState() {
    popupButtonKey = GlobalKey();
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
            initialValue: FieldsEnum.AIRDAYS,
            onSelected: sortByField,
            itemBuilder: (BuildContext c) => _fieldTile(),
            child: Icon(
              CommunityMaterialIcons.dots_horizontal,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ));
  }

  List<PopupMenuEntry<FieldsEnum>> _fieldTile() {
    final collectionBloc = context.read<CollectionBloc>();
    return FieldsEnum.getSortable()
        .map((field) => PopupMenuItem(
              value: field,
              child: ListTile(
                leading: collectionBloc.state.sortField == field.fieldName ? _leadingListTile() : const SizedBox(),
                title: Text(field.fullName),
              ),
            ))
        .toList();
  }

  Widget _leadingListTile() {
    late final IconData icon;
    final collectionBloc = context.read<CollectionBloc>();
    if (collectionBloc.state.sortBy == SortBy.ASC) {
      icon = Icons.arrow_upward;
    } else if (collectionBloc.state.sortBy == SortBy.DESC) {
      icon = Icons.arrow_downward;
    }

    return Icon(icon, color: Theme.of(context).iconTheme.color);
  }

  void sortByField(final FieldsEnum? fieldEnum) {
    if (fieldEnum == null) return;
    context.read<CollectionBloc>().add(SortByField(fieldEnum: fieldEnum));
  }
}
