part of 'form_builder.dart';

class InitialItemFormBuilder extends FormBuilder {
  InitialItemFormBuilder({required super.item});

  @override
  FormGroup _buildForm() => fb.group(<String, Object>{
        FieldsEnum.NAME.fieldName: FormControl<String>(
          value: item.name,
          validators: [Validators.required],
        ),
        FieldsEnum.ORIGINALTITLE.fieldName: FormControl<String>(value: item.originalTitle),
        FieldsEnum.PRODUCTIONYEAR.fieldName: FormControl<int>(value: item.productionYear),
        FieldsEnum.OVERVIEW.fieldName: FormControl<String>(value: item.overview),
        FieldsEnum.DATECREATED.fieldName: FormControl<DateTime>(value: item.dateCreated)
      });

  @override
  Item formToItem() {
    return item.copyWith.call(
        name: getFormValue(FieldsEnum.NAME.fieldName),
        originalTitle: getFormValue(FieldsEnum.ORIGINALTITLE.fieldName),
        productionYear: getFormValue(FieldsEnum.PRODUCTIONYEAR.fieldName),
        overview: getFormValue(FieldsEnum.OVERVIEW.fieldName),
        dateCreated: getFormValue(FieldsEnum.DATECREATED.fieldName));
  }
}
