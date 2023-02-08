part of '../fields.dart';

class CommunityRatingField extends StatelessWidget {
  const CommunityRatingField({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<double>(
        formControlName: FieldsEnum.COMMUNITYRATING.fieldName,
        validationMessages: {
          ValidationMessage.required: (_) => 'The original title must not be empty',
        },
        keyboardType: TextInputType.number,
        onSubmitted: (_) => context.read<FormBloc>().state.formBuilder.formGroup.focus(FieldsEnum.OVERVIEW.fieldName),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Community rating'));
  }
}
