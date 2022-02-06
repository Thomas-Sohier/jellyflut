part of '../fields.dart';

class OriginalTitleField extends StatelessWidget {
  final FormGroup form;

  const OriginalTitleField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.ORIGINALTITLE.getName(),
        validationMessages: (control) => {
              ValidationMessage.required:
                  'The original title must not be empty',
            },
        onSubmitted: () => form.focus(FieldsEnum.DATECREATED.getName()),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: 'Original title',
            labelStyle:
                TextStyle(color: Theme.of(context).colorScheme.onBackground),
            isDense: true,
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
