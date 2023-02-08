part of '../fields.dart';

class FontSizeField extends StatelessWidget {
  final FormGroup form;
  final String fieldName;
  final String formKey;
  const FontSizeField({super.key, required this.form, required this.fieldName, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<double>(
        formControlName: formKey,
        onSubmitted: (_) => {},
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        minLines: 1,
        maxLines: 1,
        decoration: InputDecoration(labelText: fieldName));
  }
}
