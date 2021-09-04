part of '../fields.dart';

class OverviewField extends StatelessWidget {
  final FormGroup form;
  const OverviewField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: 'overview',
        onSubmitted: () => {},
        textInputAction: TextInputAction.next,
        minLines: 3,
        maxLines: 10,
        decoration: InputDecoration(
            labelText: 'Overview',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            isDense: true,
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
