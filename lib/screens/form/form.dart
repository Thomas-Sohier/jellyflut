import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide FormState;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'forms/movie_form.dart';
import 'forms/default_form.dart';

class FormBuilder<T extends Object> extends StatelessWidget {
  const FormBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc<T>, FormState<T>>(
        listener: (context, state) {
          switch (state.formStatus) {
            case FormStatus.submitted:
              SnackbarUtil.message('form_submit_success'.tr(), Icons.check, Colors.green, context: context);
              break;
            case FormStatus.failure:
              SnackbarUtil.message('form_submit_error'.tr(), Icons.error, Colors.red, context: context);
              break;
            default:
          }
        },
        child: formSelector(context.read<FormBloc<T>>().state.value));
  }

  Widget formSelector(T value) {
    if (value is Item) {
      switch (value.type) {
        case ItemType.Movie:
          return const MovieForm();
        default:
          return const DefaultForm();
      }
    }
    return const SizedBox();
  }
}
