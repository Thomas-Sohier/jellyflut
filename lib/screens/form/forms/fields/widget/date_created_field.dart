part of '../fields.dart';

class DateCreatedField extends StatelessWidget {
  final FormGroup form;
  const DateCreatedField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<DateTime>(
        formControlName: FieldsEnum.DATECREATED.getName(),
        onSubmitted: () => form.focus(FieldsEnum.PREMIEREDATE.getName()),
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date added',
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          isDense: true,
          border: DEFAULT_BORDER,
          errorBorder: ERROR_BORDER,
          enabledBorder: ENABLED_BORDER,
          focusedBorder: FOCUSED_BORDER,
          suffixIcon: ReactiveDatePicker<DateTime>(
            formControlName: FieldsEnum.DATECREATED.getName(),
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
