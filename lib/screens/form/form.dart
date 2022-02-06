import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart' as form;

import 'forms/movie_form.dart';
import 'forms/default_form.dart';

class FormBuilder<T extends Object> extends StatefulWidget {
  final form.FormBloc<T> formBloc;

  FormBuilder({Key? key, required this.formBloc}) : super(key: key);

  @override
  FormBuilderState<T> createState() => FormBuilderState<T>();
}

class FormBuilderState<T extends Object> extends State<FormBuilder> {
  late final form.FormBloc<T> formBloc;

  @override
  void initState() {
    formBloc = widget.formBloc as form.FormBloc<T>;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<form.FormBloc<T>>.value(
        value: formBloc,
        child: BlocListener<form.FormBloc<T>, form.FormState<T>>(
            bloc: formBloc,
            listener: (context, state) {
              if (state is form.FormSubmittedState<T>) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Row(children: [
                        Flexible(child: Text(state.message)),
                        Icon(Icons.check, color: Colors.green)
                      ]),
                      width: 600));
              } else if (state is form.FormErrorState<T>) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Row(children: [
                        Flexible(child: Text(state.error)),
                        Icon(Icons.error, color: Colors.red)
                      ]),
                      width: 600));
              }
            },
            child: formSelector(formBloc.value)));
  }

  Widget formSelector(T value) {
    if (value is Item) {
      switch (value.type) {
        case ItemType.MOVIE:
          return MovieForm(item: value);
        default:
          return DefaultForm(item: value);
      }
    }
    return SizedBox();
  }
}
