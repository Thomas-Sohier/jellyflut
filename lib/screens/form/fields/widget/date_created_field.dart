part of '../fields.dart';

class DateCreatedField extends StatelessWidget {
  const DateCreatedField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<DateTime>(
        formControlName: FieldsEnum.DATECREATED.fieldName,
        onSubmitted: (_) =>
            context.read<FormBloc>().state.formBuilder.formGroup.focus(FieldsEnum.PREMIEREDATE.fieldName),
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date added',
          suffixIcon: ReactiveDatePicker<DateTime>(
            formControlName: FieldsEnum.DATECREATED.fieldName,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (context, picker, child) {
              return IconButton(
                onPressed: picker.showPicker,
                icon: const Icon(Icons.date_range),
              );
            },
          ),
        ));
  }
}
