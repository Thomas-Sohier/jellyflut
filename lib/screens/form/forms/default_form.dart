import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/screens/form/forms/fields/fields.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DefaultForm extends StatelessWidget {
  final Item item;

  DefaultForm({required this.item});

  FormGroup buildForm() => fb.group(<String, Object>{
        FieldsEnum.NAME.getName(): FormControl<String>(
          value: item.name,
          validators: [Validators.required],
        ),
        FieldsEnum.ORIGINALTITLE.getName():
            FormControl<String>(value: item.originalTitle),
        FieldsEnum.PRODUCTIONYEAR.getName():
            FormControl<int>(value: item.productionYear),
        FieldsEnum.OVERVIEW.getName():
            FormControl<String>(value: item.overview),
        FieldsEnum.DATECREATED.getName():
            FormControl<DateTime>(value: item.dateCreated)
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
      form: buildForm,
      builder: (context, form, child) {
        form.valueChanges.listen((event) {
          BlocProvider.of<DetailsBloc>(context)
              .add(DetailsItemUpdated(item: item));
        });
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
              ProductionYearField(form: form),
              const SizedBox(height: 24.0),
              OverviewField(form: form),
              const SizedBox(height: 24.0),
              DateCreatedField(form: form),
            ],
          ),
        );
      },
    );
  }
}
