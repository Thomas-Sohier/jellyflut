part of '../fields.dart';

class ServerUrlField extends StatelessWidget {
  final FormGroup form;
  final VoidCallback onSubmitted;
  const ServerUrlField(
      {Key? key, required this.form, required this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: getEnumValue(FieldsType.SERVER_URL.toString()),
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.url,
        style: INPUT_TEXT_STYLE,
        decoration: InputDecoration(
            labelText: 'server_url_field_label'.tr(),
            labelStyle: INPUT_TEXT_STYLE,
            prefixIcon: Icon(Icons.http_outlined, color: Colors.black),
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
