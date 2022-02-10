import 'dart:async';

import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/models/jellyfin/person.dart';
import 'package:jellyflut/models/jellyfin/studio.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/screens/form/forms/fields/fields.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MovieForm extends StatefulWidget {
  final Item item;

  const MovieForm({required this.item});

  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  late final FormGroup form;
  late final Item item;
  late final FormBloc<Item> _formBloc;
  late final StreamSubscription<ControlStatus> _subFormChange;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    form = buildForm();
    _subFormChange = form.statusChanged.listen((event) {});
    _subFormChange.onData((status) {
      if (status == ControlStatus.valid) {
        _formBloc.add(CurrentForm<Item>(formGroup: form, value: item));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formBloc = BlocProvider.of<FormBloc<Item>>(context);
  }

  @override
  void dispose() {
    _subFormChange.cancel();
    form.dispose();
    super.dispose();
  }

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
            FormControl<List<String?>>(value: item.genres)
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
              )),
        ));
  }
}
