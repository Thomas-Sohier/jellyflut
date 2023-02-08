import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide FormState;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/screens/form/forms/default_form.dart';
import 'package:jellyflut/screens/form/forms/movie_form.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class FormBuilder<T extends Object> extends StatelessWidget {
  const FormBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormBloc, FormState>(listener: (context, state) {
      switch (state.formStatus) {
        case FormStatus.submitted:
          SnackbarUtil.message(
              messageTitle: 'form_submit_success'.tr(), icon: Icons.check, color: Colors.green, context: context);
          break;
        case FormStatus.failure:
          SnackbarUtil.message(
              messageTitle: 'form_submit_error'.tr(), icon: Icons.error, color: Colors.red, context: context);
          break;
        default:
      }
    }, builder: (_, state) {
      switch (state.formStatus) {
        case FormStatus.loading:
          return const Center(
            child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
          );
        case FormStatus.failure:
        case FormStatus.loaded:
          return const FormLoader();
        default:
          return const NoForm();
      }
    });
  }
}

class FormLoader extends StatelessWidget {
  const FormLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final item = context.read<FormBloc>().state.item;
    switch (item.type) {
      case ItemType.Movie:
        return const MovieForm();
      default:
        return const DefaultForm();
    }
  }
}

class NoForm extends StatelessWidget {
  const NoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No form found to edit this'),
    );
  }
}
