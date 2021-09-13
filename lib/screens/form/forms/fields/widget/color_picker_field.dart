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
    // ReactiveTextField<double>(
    //     formControlName: 'font_size',
    //     onSubmitted: () => {},
    //     textInputAction: TextInputAction.next,
    //     keyboardType: TextInputType.number,
    //     minLines: 1,
    //     maxLines: 1,
    //     decoration: InputDecoration(
    //         labelText: 'Font Size',
    //         labelStyle: TextStyle(color: Theme.of(context).primaryColor),
    //         isDense: true,
    //         border: DEFAULT_BORDER,
    //         errorBorder: ERROR_BORDER,
    //         enabledBorder: ENABLED_BORDER,
    //         focusedBorder: FOCUSED_BORDER));
  }
}
