part of '../fields.dart';

class OriginalTitleField extends StatelessWidget {
  const OriginalTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.ORIGINALTITLE.fieldName,
        validationMessages: (control) => {
              ValidationMessage.required: 'The original title must not be empty',
            },
        onSubmitted: () => context.read<FormBloc<Item>>().state.form.focus(FieldsEnum.DATECREATED.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Original title'));
  }
}
