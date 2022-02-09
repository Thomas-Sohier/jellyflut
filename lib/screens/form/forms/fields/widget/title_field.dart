part of '../fields.dart';

class TitleField extends StatelessWidget {
  final FormGroup form;
  const TitleField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsEnum.NAME.getName(),
        validationMessages: (control) =>
            {ValidationMessage.required: 'The title must not be empty'},
        onSubmitted: () => form.focus(FieldsEnum.ORIGINALTITLE.getName()),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Title'));
  }
}
