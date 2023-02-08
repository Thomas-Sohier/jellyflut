part of '../fields.dart';

class ServerNameField extends StatelessWidget {
  final FormGroup form;
  final Function(FormControl<String>)? onSubmitted;

  const ServerNameField({super.key, required this.form, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsType.SERVER_NAME.value,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        autofocus: true,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(labelText: 'server_name_field_label'.tr(), prefixIcon: Icon(Icons.label)));
  }
}
