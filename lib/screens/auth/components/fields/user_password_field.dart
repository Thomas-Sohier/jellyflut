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
        formControlName: 'user_password',
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        style: INPUT_TEXT_STYLE,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: INPUT_TEXT_STYLE,
            prefixIcon: Icon(Icons.password, color: Colors.black),
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
