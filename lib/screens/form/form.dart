import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart' as form;
import 'package:jellyflut/theme.dart' as personnal_theme;

import 'forms/movie_form.dart';
import 'forms/default_form.dart';

class FormBuilder extends StatefulWidget {
  final Item item;
  final VoidCallback onSuccess;
  final VoidCallback onError;

  FormBuilder(
      {Key? key,
      required this.item,
      this.onSuccess = _defaultFunction,
      this.onError = _defaultFunction})
      : super(key: key);

  static void _defaultFunction() {}

  @override
  FormBuilderState createState() => FormBuilderState();
}

class FormBuilderState extends State<FormBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<form.FormBloc, form.FormState>(
      listener: (context, state) {
        if (state is form.FormValidState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(children: [
                  Text(state.message),
                  Spacer(),
                  Icon(Icons.check, color: Colors.green)
                ]),
                width: 600));
          widget.onSuccess();
        } else if (state is form.FormErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(children: [
                  Text(state.error),
                  Spacer(),
                  Icon(Icons.error, color: Colors.red)
                ]),
                width: 600));
          widget.onError();
        }
      },
      child: Theme(
          data: personnal_theme.Theme.defaultThemeData.copyWith(
              textTheme:
                  personnal_theme.Theme.getTextThemeWithColor(Colors.white)),
          child: formSelector(widget.item)),
    );
  }

  Widget formSelector(Item item) {
    switch (item.type) {
      case ItemType.MOVIE:
        return MovieForm(item: item);
      default:
        return DefaultForm(item: item);
    }
  }
}
