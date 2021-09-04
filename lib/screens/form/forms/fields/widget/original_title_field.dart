part of '../fields.dart';

class OriginalTitleField extends StatelessWidget {
  final FormGroup form;

  const OriginalTitleField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: 'original_title',
        validationMessages: (control) => {
              ValidationMessage.required:
                  'The original title must not be empty',
            },
        onSubmitted: () => form.focus('date_added'),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: 'Original title',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            isDense: true,
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
