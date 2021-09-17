part of '../fields.dart';

class UserUsernameField extends StatelessWidget {
  final FormGroup form;
  final VoidCallback onSubmitted;

  const UserUsernameField(
      {Key? key, required this.form, required this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: getEnumValue(FieldsType.USER_USERNAME.toString()),
        onSubmitted: onSubmitted,
        autofocus: true,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        style: INPUT_TEXT_STYLE,
        decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: INPUT_TEXT_STYLE,
            prefixIcon: Icon(Icons.person_outline, color: Colors.black),
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
