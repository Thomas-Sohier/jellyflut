part of '../fields.dart';

class ProductionYearField extends StatelessWidget {
  const ProductionYearField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<int>(
        formControlName: FieldsEnum.PRODUCTIONYEAR.fieldName,
        keyboardType: TextInputType.number,
        onSubmitted: () => context.read<FormBloc<Item>>().state.form.focus(FieldsEnum.OVERVIEW.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Year'));
  }
}
