part of '../fields.dart';

class YearField extends StatelessWidget {
  final FormGroup form;
  const YearField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<int>(
        formControlName: 'year',
        keyboardType: TextInputType.number,
        onSubmitted: () => form.focus('overview'),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: 'Year',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            isDense: true,
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
