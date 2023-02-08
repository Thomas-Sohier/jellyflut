part of '../fields.dart';

class UserUsernameField extends StatelessWidget {
  final FormGroup form;
  final Function(FormControl<String>)? onSubmitted;

  const UserUsernameField({super.key, required this.form, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsType.USER_USERNAME.value,
        onSubmitted: onSubmitted,
        autofocus: true,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration:
            InputDecoration(labelText: 'user_username_field_label'.tr(), prefixIcon: Icon(Icons.person_outline)));
  }
}
