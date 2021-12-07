part of '../fields.dart';

class PremiereDateField extends StatelessWidget {
  final FormGroup form;
  const PremiereDateField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<DateTime>(
        formControlName: FieldsEnum.PREMIEREDATE.getName(),
        onSubmitted: () => form.focus(FieldsEnum.PRODUCTIONYEAR.getName()),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Premiere date',
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          isDense: true,
          border: DEFAULT_BORDER,
          errorBorder: ERROR_BORDER,
          enabledBorder: ENABLED_BORDER,
          focusedBorder: FOCUSED_BORDER,
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
