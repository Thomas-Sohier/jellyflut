part of '../fields.dart';

class UserPasswordField extends StatelessWidget {
  final FormGroup form;
  final VoidCallback onSubmitted;

  const UserPasswordField(
      {Key? key, required this.form, required this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsType.USER_PASSWORD.getValue(),
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        style: INPUT_TEXT_STYLE,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'user_password_field_label'.tr(),
            labelStyle: INPUT_TEXT_STYLE,
            prefixIcon: Icon(Icons.password, color: Colors.black),
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
