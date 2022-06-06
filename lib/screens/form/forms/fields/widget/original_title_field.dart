part of '../fields.dart';

class OriginalTitleField extends StatelessWidget {
  final FormGroup form;

  const OriginalTitleField({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.ORIGINALTITLE.name,
        validationMessages: (control) => {
              ValidationMessage.required:
                  'The original title must not be empty',
            },
        onSubmitted: () => form.focus(FieldsEnum.DATECREATED.name),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Original title'));
  }
}
