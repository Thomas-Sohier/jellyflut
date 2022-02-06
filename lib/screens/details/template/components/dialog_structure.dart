import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/screens/form/form.dart';

class DialogStructure extends StatelessWidget {
  final void Function() onClose;
  final void Function() onSubmit;
  final bool expanded;
  final FormBloc<Item> formBloc;

  const DialogStructure(
      {Key? key,
      this.expanded = false,
      required this.onClose,
      required this.onSubmit,
      required this.formBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.background,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            DecoratedBox(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black26))),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: onClose,
                            icon: Icon(Icons.close)),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text('edit_infos'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline5),
                        ),
                      ],
                    ))),
            form(),
            DecoratedBox(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Colors.black26))),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: onClose, child: Text('cancel'.tr())),
                        TextButton(
                            onPressed: onSubmit, child: Text('edit'.tr()))
                      ]),
                )),
          ]),
    );
  }

  Widget form() {
    if (expanded) {
      return Expanded(child: FormBuilder<Item>(formBloc: formBloc));
    }
    return Flexible(child: FormBuilder<Item>(formBloc: formBloc));
  }
}
