part of '../fields.dart';

class DateAddedField extends StatelessWidget {
  final FormGroup form;
  const DateAddedField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<DateTime>(
        formControlName: 'date_added',
        onSubmitted: () => form.focus('premiere_date'),
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
            formControlName: 'date_added',
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
