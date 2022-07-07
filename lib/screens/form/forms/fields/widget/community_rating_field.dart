part of '../fields.dart';

class CommunityRatingField extends StatelessWidget {
  const CommunityRatingField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<double>(
        formControlName: FieldsEnum.COMMUNITYRATING.fieldName,
        validationMessages: (control) => {
              ValidationMessage.required: 'The original title must not be empty',
            },
        keyboardType: TextInputType.number,
        onSubmitted: () => context.read<FormBloc<Item>>().state.form.focus(FieldsEnum.OVERVIEW.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Community rating'));
  }
}
