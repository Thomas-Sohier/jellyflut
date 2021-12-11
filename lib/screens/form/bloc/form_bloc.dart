import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc<T extends Object> extends Bloc<FormEvent<T>, FormState<T>> {
  FormBloc() : super(RefreshedState(form: FormGroup({})));

  late FormGroup formGroup;
  late T value;

  @override
  Stream<FormState<T>> mapEventToState(FormEvent<T> event) async* {
    if (event is CurrentForm<T>) {
      formGroup = event.formGroup;
      value = event.value;
    } else if (event is FormSubmitted && value is Item) {
      yield* _updateItem(value);
    } else if (event is RefreshForm) {
      yield RefreshedState(form: FormGroup({}));
    }
  }

  Stream<FormState<T>> _updateItem(final T item) async* {
    formGroup.markAllAsTouched();
    if (formGroup.valid) {
      // Add necesary data to the item to update it
      final form = Map<String, Object?>.from(formGroup.value);
      _defaultRequiredValue(form, item as Item);

      // Update item
      try {
        await ItemService.updateItemFromForm(id: item.id, form: form);
        yield FormValidState<T>(
            message: 'Item updated', value: value, form: formGroup);
      } catch (error) {
        yield FormErrorState(form: formGroup, error: error.toString());
      }
    }
  }

  void _defaultRequiredValue(final Map<String, Object?> form, final Item item) {
    form.putIfAbsent(
        FieldsEnum.ALBUMARTISTS.getName(), () => item.albumArtist ?? []);
    form.putIfAbsent(
        FieldsEnum.ARTISTITEMS.getName(), () => item.artistItems ?? []);
    form.putIfAbsent(FieldsEnum.PEOPLE.getName(), () => item.people ?? []);
    form.putIfAbsent(FieldsEnum.AIRDAYS.getName(), () => []);
    form.putIfAbsent(FieldsEnum.GENRES.getName(), () => item.genres ?? []);
    form.putIfAbsent(FieldsEnum.TAGS.getName(), () => item.tags ?? []);
    form.putIfAbsent(
        FieldsEnum.LOCKEDFIELDS.getName(), () => item.lockedFields ?? []);
    form.putIfAbsent(
        FieldsEnum.PROVIDERIDS.getName(), () => item.providerIds ?? []);
  }
}
