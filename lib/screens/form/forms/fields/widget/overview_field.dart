part of '../fields.dart';

class OverviewField extends StatelessWidget {
  final FormGroup form;
  const OverviewField({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.OVERVIEW.getName(),
        onSubmitted: () => {},
        textInputAction: TextInputAction.next,
        minLines: 3,
        maxLines: 10,
        decoration: InputDecoration(labelText: 'Overview'));
  }
}
