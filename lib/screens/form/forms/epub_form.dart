import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:jellyflut/screens/form/forms/fields/fields.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EpubForm extends StatelessWidget {
  final double fontSize;
  final Color fontColor;
  final Color backgroundColor;

  const EpubForm(
      {this.fontSize = 18,
      this.fontColor = const Color.fromARGB(255, 251, 240, 217),
      this.backgroundColor = Colors.black});

  FormGroup buildForm() => fb.group(<String, Object>{
        FieldsEnum.FONTSIZE.getName(): FormControl<double>(
          value: fontSize,
          validators: [Validators.required],
        ),
        FieldsEnum.FONTCOLOR.getName(): FormControl<Color>(value: fontColor),
        FieldsEnum.BACKGROUNDCOLOR.getName():
            FormControl<Color>(value: backgroundColor),
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
              FontSizeField(
                form: form,
                fieldName: 'Font size',
                formKey: FieldsEnum.FONTSIZE.getName(),
              ),
              const SizedBox(height: 24.0),
              ColorPickerField(
                form: form,
                fieldName: 'Font color',
                formKey: FieldsEnum.FONTCOLOR.getName(),
              ),
              const SizedBox(height: 24.0),
              ColorPickerField(
                form: form,
                fieldName: 'Background color',
                formKey: FieldsEnum.BACKGROUNDCOLOR.getName(),
              )
            ],
          ),
        );
      },
    );
  }
}
