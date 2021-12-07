part of '../fields.dart';

class CommunityRatingField extends StatelessWidget {
  final FormGroup form;
  const CommunityRatingField({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<double>(
        formControlName: FieldsEnum.COMMUNITYRATING.getName(),
        validationMessages: (control) => {
              ValidationMessage.required:
                  'The original title must not be empty',
            },
        keyboardType: TextInputType.number,
        onSubmitted: () => form.focus(FieldsEnum.OVERVIEW.getName()),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: 'Community rating',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            isDense: true,
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
