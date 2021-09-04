import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/enum/itemType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart' as form;
import 'package:reactive_forms/reactive_forms.dart';

import 'forms/movie_form.dart';
import 'forms/default_form.dart';

class FormBuilder extends StatefulWidget {
  final Item item;

  FormBuilder({Key? key, required this.item}) : super(key: key);

  @override
  FormBuilderState createState() => FormBuilderState();
}

class FormBuilderState extends State<FormBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<form.FormBloc, form.FormState>(
      listener: (context, state) {
        switch (state.form.status) {
          case ControlStatus.valid:
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            break;
          case ControlStatus.pending:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Submitting...')),
              );
            break;
          default:
        }
      },
      child: formSelector(widget.item),
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
