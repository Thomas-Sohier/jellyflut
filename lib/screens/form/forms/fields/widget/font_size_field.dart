part of '../fields.dart';

class FontSizeField extends StatelessWidget {
  final FormGroup form;
  final String fieldName;
  final String formKey;
  const FontSizeField(
      {Key? key,
      required this.form,
      required this.fieldName,
      required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<double>(
        formControlName: formKey,
        onSubmitted: () => {},
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        minLines: 1,
        maxLines: 1,
        decoration: InputDecoration(
            labelText: fieldName,
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            isDense: true,
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
