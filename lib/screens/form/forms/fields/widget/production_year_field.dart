part of '../fields.dart';

class ProductionYearField extends StatelessWidget {
  final FormGroup form;
  const ProductionYearField({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<int>(
        formControlName: FieldsEnum.PRODUCTIONYEAR.getName(),
        keyboardType: TextInputType.number,
        onSubmitted: () => form.focus(FieldsEnum.OVERVIEW.getName()),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Year'));
  }
}
