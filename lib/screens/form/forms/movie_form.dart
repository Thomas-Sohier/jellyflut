import 'package:flutter/material.dart' hide ProgressIndicator, FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';

import 'package:reactive_forms/reactive_forms.dart';

import '../fields/fields.dart';

class MovieForm extends StatelessWidget {
  const MovieForm({super.key});

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
                  const CommunityRatingField(),
                  const SizedBox(height: 24.0),
                  const DateCreatedField(),
                  const SizedBox(height: 24.0),
                  const PremiereDateField(),
                  const SizedBox(height: 24.0),
                  const ProductionYearField(),
                  const SizedBox(height: 24.0),
                  const OverviewField(),
                  const SizedBox(height: 24.0),
                  const PersonField(),
                  const SizedBox(height: 24.0),
                  const StudiosField(),
                  const SizedBox(height: 24.0),
                  const GenresField(),
                  const SizedBox(height: 24.0),
                  const TagsField(),
                ],
              )),
        ));
  }
}
