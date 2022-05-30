part of '../fields.dart';

class PremiereDateField extends StatelessWidget {
  final FormGroup form;
  const PremiereDateField({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<DateTime>(
        formControlName: FieldsEnum.PREMIEREDATE.getName(),
        onSubmitted: () => form.focus(FieldsEnum.PRODUCTIONYEAR.getName()),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Premiere date',
          suffixIcon: ReactiveDatePicker<DateTime>(
            formControlName: FieldsEnum.DATEADDED.getName(),
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
