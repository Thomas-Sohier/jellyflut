import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reactive_forms/reactive_forms.dart';

import '../bloc/form_bloc.dart';

class EpubForm extends StatelessWidget {
  final double fontSize;
  final Color fontColor;
  final Color backgroundColor;

  const EpubForm(
      {this.fontSize = 18,
      this.fontColor = const Color.fromARGB(255, 251, 240, 217),
      this.backgroundColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: context.read<FormBloc>().state.formBuilder.formGroup,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12.0),
              // FontSizeField(
              //   form: form,
              //   fieldName: 'Font size',
              //   formKey: FieldsEnum.FONTSIZE.fieldName,
              // ),
              // const SizedBox(height: 24.0),
              // ColorPickerField(
              //   form: form,
              //   fieldName: 'Font color',
              //   formKey: FieldsEnum.FONTCOLOR.fieldName,
              // ),
              // const SizedBox(height: 24.0),
              // ColorPickerField(
              //   form: form,
              //   fieldName: 'Background color',
              //   formKey: FieldsEnum.BACKGROUNDCOLOR.fieldName,
              // )
            ],
          ),
        ));
  }
}
