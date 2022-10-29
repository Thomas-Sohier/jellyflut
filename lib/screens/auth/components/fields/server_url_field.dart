part of '../fields.dart';

class ServerUrlField extends StatelessWidget {
  final FormGroup form;
  final Function(FormControl<String>)? onSubmitted;
  const ServerUrlField({super.key, required this.form, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsType.SERVER_URL.value,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(labelText: 'server_url_field_label'.tr(), prefixIcon: Icon(Icons.http_outlined)));
  }
}
