part of '../fields.dart';

class UserPasswordField extends StatelessWidget {
  final FormGroup form;
  final VoidCallback onSubmitted;

  const UserPasswordField(
      {super.key, required this.form, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsType.USER_PASSWORD.getValue(),
        onSubmitted: onSubmitted,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'user_password_field_label'.tr(),
            prefixIcon: Icon(Icons.password)));
  }
}
