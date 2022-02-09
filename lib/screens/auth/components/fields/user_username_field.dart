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
        formControlName: FieldsType.USER_USERNAME.getValue(),
        onSubmitted: onSubmitted,
        autofocus: true,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: 'user_username_field_label'.tr(),
            prefixIcon: Icon(Icons.person_outline)));
  }
}
