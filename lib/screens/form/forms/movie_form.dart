import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/jellyfin/genre_item.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/models/jellyfin/person.dart';
import 'package:jellyflut/models/jellyfin/studio.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/screens/form/forms/fields/fields.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MovieForm extends StatelessWidget {
  final Item item;

  MovieForm({required this.item});

  FormGroup buildForm() => fb.group(<String, Object>{
        FieldsEnum.NAME.getName(): FormControl<String>(
          value: item.name,
          validators: [Validators.required],
        ),
        FieldsEnum.ORIGINALTITLE.getName():
            FormControl<String>(value: item.originalTitle),
        FieldsEnum.COMMUNITYRATING.getName():
            FormControl<double>(value: item.communityRating),
        FieldsEnum.DATECREATED.getName():
            FormControl<DateTime>(value: item.dateCreated),
        FieldsEnum.OVERVIEW.getName():
            FormControl<String>(value: item.overview),
        FieldsEnum.PREMIEREDATE.getName():
            FormControl<DateTime>(value: item.premiereDate),
        FieldsEnum.PRODUCTIONYEAR.getName():
            FormControl<int>(value: item.productionYear),
        FieldsEnum.DATEADDED.getName():
            FormControl<DateTime>(value: item.dateCreated),
        FieldsEnum.PEOPLE.getName():
            FormControl<List<Person>>(value: item.people),
        FieldsEnum.STUDIOS.getName():
            FormControl<List<Studio>>(value: item.studios),
        FieldsEnum.TAGS.getName(): FormControl<List<dynamic>>(value: item.tags),
        FieldsEnum.GENRES.getName():
            FormControl<List<GenreItem>>(value: item.genreItems)
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
      form: buildForm,
      builder: (context, form, child) {
        BlocProvider.of<FormBloc>(context)
            .add(CurrentForm(formGroup: form, item: item));
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12.0),
              TitleField(form: form),
              const SizedBox(height: 24.0),
              OriginalTitleField(form: form),
              const SizedBox(height: 24.0),
              CommunityRatingField(form: form),
              const SizedBox(height: 24.0),
              DateCreatedField(form: form),
              const SizedBox(height: 24.0),
              PremiereDateField(form: form),
              const SizedBox(height: 24.0),
              ProductionYearField(form: form),
              const SizedBox(height: 24.0),
              OverviewField(form: form),
              const SizedBox(height: 24.0),
              PersonField(form: form, item: item),
              const SizedBox(height: 24.0),
              StudiosField(form: form, item: item),
              const SizedBox(height: 24.0),
              GenresField(form: form, item: item),
              const SizedBox(height: 24.0),
              TagsField(form: form, item: item),
            ],
          ),
        );
      },
    );
  }
}
