import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc<T extends Object> extends Bloc<FormEvent<T>, FormState<T>> {
  final ItemsRepository _itemsRepository;

  FormBloc({required ItemsRepository itemsRepository, required T value})
      : _itemsRepository = itemsRepository,
        super(FormState<T>(form: FormGroup({}), value: value)) {
    on<UpdateForm<T>>(_updateFormValue);
    on<FormSubmitted<T>>(_submitForm);
    on<ResetForm<T>>(_resetForm);
  }

  void _updateFormValue(UpdateForm<T> event, Emitter<FormState<T>> emit) {
    emit(state.copyWith(form: event.formGroup));
  }

  void _resetForm(ResetForm<T> event, Emitter<FormState<T>> emit) {
    emit(state.copyWith(form: FormGroup({}), formStatus: FormStatus.initial));
  }

  Future<void> _submitForm(FormSubmitted<T> event, Emitter<FormState<T>> emit) async {
    state.form.markAllAsTouched();
    if (state.form.valid) {
      final form = _defaultRequiredValue();
      final item = _parseFormToValue(form);

      // Update item
      await _itemsRepository
          .updateItemFromItem(item: item)
          .then((_) => emit(state.copyWith(value: state.value, form: state.form, formStatus: FormStatus.submitted)))
          .onError((_, __) => emit(state.copyWith(form: state.form, formStatus: FormStatus.failure)));
    }
  }

  Map<String, Object?> _defaultRequiredValue() {
    Item item() => state.value as Item;
    final form = {...state.form.value};
    // form.putIfAbsent([], () => item().tags);
    form.putIfAbsent(FieldsEnum.ALBUMARTISTS.fieldName, () => item().albumArtists);
    form.putIfAbsent(FieldsEnum.ARTISTITEMS.fieldName, () => item().artistItems);
    form.putIfAbsent(FieldsEnum.PEOPLE.fieldName, () => item().people);
    // form.putIfAbsent(FieldsEnum.AIRDAYS.fieldName, () => []);
    form.putIfAbsent(FieldsEnum.GENRES.fieldName, () => item().genres);
    form.putIfAbsent(FieldsEnum.TAGS.fieldName, () => item().tags);
    form.putIfAbsent(FieldsEnum.LOCKEDFIELDS.fieldName, () => item().lockedFields);
    form.putIfAbsent(FieldsEnum.PROVIDERIDS.fieldName, () => item().providerIds);
    return form;
  }

  Item _parseFormToValue(final Map<String, Object?> form) {
    final item = state.value as Item;
    form.forEach((key, value) {
      item[key] = value;
    });
    return item;
  }
}
