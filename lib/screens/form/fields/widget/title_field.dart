part of '../fields.dart';

class TitleField extends StatelessWidget {
  const TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.NAME.fieldName,
        validationMessages: {
          ValidationMessage.required: (_) => 'The title must not be empty',
        },
        onSubmitted: (_) =>
            context.read<FormBloc>().state.formBuilder.formGroup.focus(FieldsEnum.ORIGINALTITLE.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Title'));
  }
}
