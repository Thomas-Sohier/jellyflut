import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/screens/form/forms/fields/fields.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'package:reactive_forms/reactive_forms.dart';

class MovieForm extends StatelessWidget {
  const MovieForm({super.key});

  FormGroup buildForm(Item item) => fb.group(<String, Object>{
        FieldsEnum.NAME.fieldName: FormControl<String>(
          value: item.name,
          validators: [Validators.required],
        ),
        FieldsEnum.ORIGINALTITLE.fieldName: FormControl<String>(value: item.originalTitle),
        FieldsEnum.COMMUNITYRATING.fieldName: FormControl<double>(value: item.communityRating),
        FieldsEnum.DATECREATED.fieldName: FormControl<DateTime>(value: item.dateCreated),
        FieldsEnum.OVERVIEW.fieldName: FormControl<String>(value: item.overview),
        FieldsEnum.PREMIEREDATE.fieldName: FormControl<DateTime>(value: item.premiereDate),
        FieldsEnum.PRODUCTIONYEAR.fieldName: FormControl<int>(value: item.productionYear),
        FieldsEnum.DATEADDED.fieldName: FormControl<DateTime>(value: item.dateCreated),
        FieldsEnum.PEOPLE.fieldName: FormControl<List<People>>(value: item.people),
        FieldsEnum.STUDIOS.fieldName: FormControl<List<NamedGuidPair>>(value: item.studios),
        FieldsEnum.TAGS.fieldName: FormControl<List<dynamic>>(value: item.tags),
        FieldsEnum.GENRES.fieldName: FormControl<List<String?>>(value: item.genres)
      });

  @override
  Widget build(BuildContext context) {
    final form = buildForm(context.read<FormBloc<Item>>().state.value);
    context.read<FormBloc<Item>>().add(UpdateForm(formGroup: form));

    return ReactiveForm(
        formGroup: form,
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
