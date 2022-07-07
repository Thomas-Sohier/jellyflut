part of '../fields.dart';

class TitleField extends StatelessWidget {
  const TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.NAME.fieldName,
        validationMessages: (control) => {ValidationMessage.required: 'The title must not be empty'},
        onSubmitted: () => context.read<FormBloc<Item>>().state.form.focus(FieldsEnum.ORIGINALTITLE.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Title'));
  }
}
