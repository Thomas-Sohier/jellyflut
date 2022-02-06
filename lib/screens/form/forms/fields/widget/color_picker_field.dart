part of '../fields.dart';

class ColorPickerField extends StatelessWidget {
  final FormGroup form;
  final String fieldName;
  final String formKey;
  const ColorPickerField(
      {Key? key,
      required this.form,
      required this.fieldName,
      required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(fieldName),
        BlockPicker(
            pickerColor: form.value[formKey] as Color,
            onColorChanged: (Color selectedColor) =>
                form.patchValue({formKey: selectedColor})),
      ],
    );
  }
}
