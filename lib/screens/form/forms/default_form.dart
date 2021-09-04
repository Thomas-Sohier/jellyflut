import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/forms/fields/fields.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DefaultForm extends StatelessWidget {
  final Item item;

  DefaultForm({required this.item});

  FormGroup buildForm() => fb.group(<String, Object>{
        'title': FormControl<String>(
          value: item.name,
          validators: [Validators.required],
        ),
        'original_title': FormControl<String>(value: item.originalTitle),
        'year': FormControl<int>(value: item.productionYear),
        'overview': FormControl<String>(value: item.overview),
        'date_added': FormControl<DateTime>(value: item.dateCreated)
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
      form: buildForm,
      builder: (context, form, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12.0),
              TitleField(form: form),
              const SizedBox(height: 24.0),
              OriginalTitleField(form: form),
              const SizedBox(height: 24.0),
              DateAddedField(form: form),
              const SizedBox(height: 24.0),
              YearField(form: form),
              const SizedBox(height: 24.0),
              OverviewField(form: form),
            ],
          ),
        );
      },
    );
  }
}
