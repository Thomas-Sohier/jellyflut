import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'package:reactive_forms/reactive_forms.dart';

import '../bloc/form_bloc.dart';
import 'fields/fields.dart';
import 'fields/fields_enum.dart';

class DefaultForm extends StatelessWidget {
  const DefaultForm({super.key});

  FormGroup buildForm(Item item) => fb.group(<String, Object>{
        FieldsEnum.NAME.fieldName: FormControl<String>(
          value: item.name,
          validators: [Validators.required],
        ),
        FieldsEnum.ORIGINALTITLE.fieldName: FormControl<String>(value: item.originalTitle),
        FieldsEnum.PRODUCTIONYEAR.fieldName: FormControl<int>(value: item.productionYear),
        FieldsEnum.OVERVIEW.fieldName: FormControl<String>(value: item.overview),
        FieldsEnum.DATECREATED.fieldName: FormControl<DateTime>(value: item.dateCreated)
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
