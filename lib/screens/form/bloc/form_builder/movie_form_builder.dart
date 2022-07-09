part of 'form_builder.dart';

class MovieFormBuilder extends FormBuilder {
  MovieFormBuilder({required super.item});

  @override
  FormGroup _buildForm() => fb.group(<String, Object>{
        FieldsEnum.NAME.fieldName: FormControl<String>(
          value: item.name,
          validators: [Validators.required],
        ),
        FieldsEnum.ORIGINALTITLE.fieldName: FormControl<String>(value: item.originalTitle),
        FieldsEnum.COMMUNITYRATING.fieldName: FormControl<double>(value: item.communityRating),
        FieldsEnum.DATECREATED.fieldName: FormControl<DateTime>(value: item.dateCreated),
        FieldsEnum.OVERVIEW.fieldName: FormControl<String>(value: item.overview),
        FieldsEnum.PREMIEREDATE.fieldName: FormControl<DateTime>(value: item.premiereDate),
        FieldsEnum.PRODUCTIONYEAR.fieldName: FormControl<int>(value: item.productionYear),
        FieldsEnum.PEOPLE.fieldName: FormControl<List<People>>(value: item.people),
        FieldsEnum.STUDIOS.fieldName: FormControl<List<NamedGuidPair>>(value: item.studios),
        FieldsEnum.TAGS.fieldName: FormControl<List<String>>(value: item.tags),
        FieldsEnum.GENRES.fieldName: FormControl<List<String?>>(value: item.genres)
      });

  @override
  Item formToItem() {
    return item.copyWith.call(
        name: getFormValue(FieldsEnum.NAME.fieldName),
        originalTitle: getFormValue(FieldsEnum.ORIGINALTITLE.fieldName),
        communityRating: getFormValue(FieldsEnum.COMMUNITYRATING.fieldName),
        dateCreated: getFormValue(FieldsEnum.DATECREATED.fieldName),
        overview: getFormValue(FieldsEnum.OVERVIEW.fieldName),
        premiereDate: getFormValue(FieldsEnum.PREMIEREDATE.fieldName),
        productionYear: getFormValue(FieldsEnum.PRODUCTIONYEAR.fieldName),
        people: getFormValue(FieldsEnum.PEOPLE.fieldName),
        studios: getFormValue(FieldsEnum.STUDIOS.fieldName),
        tags: getFormValue(FieldsEnum.TAGS.fieldName),
        genres: getFormValue(FieldsEnum.GENRES.fieldName));
  }
}
