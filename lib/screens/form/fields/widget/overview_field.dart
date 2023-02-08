part of '../fields.dart';

class OverviewField extends StatelessWidget {
  const OverviewField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.OVERVIEW.fieldName,
        onSubmitted: (_) => {},
        textInputAction: TextInputAction.next,
        minLines: 3,
        maxLines: 10,
        decoration: InputDecoration(labelText: 'Overview'));
  }
}
