part of '../fields.dart';

class DateCreatedField extends StatelessWidget {
  final FormGroup form;
  const DateCreatedField({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<DateTime>(
        formControlName: FieldsEnum.DATECREATED.name,
        onSubmitted: () => form.focus(FieldsEnum.PREMIEREDATE.name),
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date added',
          suffixIcon: ReactiveDatePicker<DateTime>(
            formControlName: FieldsEnum.DATECREATED.name,
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
