import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:jellyflut/screens/form/forms/fields/fields.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EpubForm extends StatelessWidget {
  final double fontSize;
  final Color fontColor;
  final Color backgroundColor;

  EpubForm(
      {required this.fontSize,
      required this.fontColor,
      required this.backgroundColor});

  FormGroup buildForm() => fb.group(<String, Object>{
        'font_size': FormControl<double>(
          value: fontSize,
          validators: [Validators.required],
        ),
        'font_color': FormControl<Color>(value: fontColor),
        'background_color': FormControl<Color>(value: backgroundColor),
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
              FontSizeField(form: form),
              const SizedBox(height: 24.0),
              ColorPickerField(
                form: form,
                fieldName: 'Font color',
                formKey: 'font_color',
              ),
              const SizedBox(height: 24.0),
              ColorPickerField(
                form: form,
                fieldName: 'Background color',
                formKey: 'background_color',
              )
            ],
          ),
        );
      },
    );
  }
}
