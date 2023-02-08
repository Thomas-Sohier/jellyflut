part of '../fields.dart';

class OriginalTitleField extends StatelessWidget {
  const OriginalTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.ORIGINALTITLE.fieldName,
        validationMessages: {
          ValidationMessage.required: (_) => 'The original title must not be empty',
        },
        onSubmitted: (_) =>
            context.read<FormBloc>().state.formBuilder.formGroup.focus(FieldsEnum.DATECREATED.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Original title'));
  }
}
