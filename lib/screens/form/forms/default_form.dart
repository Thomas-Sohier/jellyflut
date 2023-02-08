import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reactive_forms/reactive_forms.dart';

import '../bloc/form_bloc.dart';
import '../fields/fields.dart';

class DefaultForm extends StatelessWidget {
  const DefaultForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: context.read<FormBloc>().state.formBuilder.formGroup,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                const TitleField(),
                const SizedBox(height: 24.0),
                const OriginalTitleField(),
                const SizedBox(height: 24.0),
                const ProductionYearField(),
                const SizedBox(height: 24.0),
                const OverviewField(),
                const SizedBox(height: 24.0),
                const DateCreatedField(),
              ],
            ),
          ),
        ));
  }
}
