part of '../fields.dart';

class ProductionYearField extends StatelessWidget {
  const ProductionYearField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<int>(
        formControlName: FieldsEnum.PRODUCTIONYEAR.fieldName,
        keyboardType: TextInputType.number,
        onSubmitted: (_) => context.read<FormBloc>().state.formBuilder.formGroup.focus(FieldsEnum.OVERVIEW.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Year'));
  }
}
