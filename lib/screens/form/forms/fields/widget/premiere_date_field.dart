part of '../fields.dart';

class PremiereDateField extends StatelessWidget {
  const PremiereDateField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<DateTime>(
        formControlName: FieldsEnum.PREMIEREDATE.fieldName,
        onSubmitted: () => context.read<FormBloc<Item>>().state.form.focus(FieldsEnum.PRODUCTIONYEAR.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Premiere date',
          suffixIcon: ReactiveDatePicker<DateTime>(
            formControlName: FieldsEnum.DATEADDED.fieldName,
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
