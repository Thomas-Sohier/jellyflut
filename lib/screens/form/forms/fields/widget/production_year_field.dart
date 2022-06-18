part of '../fields.dart';

class ProductionYearField extends StatelessWidget {
  final FormGroup form;
  const ProductionYearField({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<int>(
        formControlName: FieldsEnum.PRODUCTIONYEAR.name,
        keyboardType: TextInputType.number,
        onSubmitted: () => form.focus(FieldsEnum.OVERVIEW.name),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Year'));
  }
}
