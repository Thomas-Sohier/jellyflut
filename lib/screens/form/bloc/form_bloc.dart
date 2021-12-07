import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/json_serializer.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  FormBloc() : super(FormState(form: FormGroup({})));

  late FormGroup formGroup;
  late Item item;

  @override
  Stream<FormState> mapEventToState(FormEvent event) async* {
    if (event is CurrentForm) {
      formGroup = event.formGroup;
      item = event.item;
    } else if (event is FormSubmitted) {
      formGroup.markAllAsTouched();
      if (formGroup.valid) {
        // Add necesary data to the item to uodate it
        final form = Map<String, Object?>.from(formGroup.value);
        _defaultRequiredValue(form);

        // Update item
        await ItemService.updateItemFromForm(id: item.id, form: form)
            .then((value) => null)
            .catchError((error) {
          log(error.toString());
          // yield FormErrorState(form: formGroup, error: error.toString());
        });
      }
    }
  }

  void _defaultRequiredValue(Map<String, Object?> form) {
    form.putIfAbsent(
        FieldsEnum.ALBUMARTISTS.getName(), () => item.albumArtist ?? []);
    form.putIfAbsent(
        FieldsEnum.ARTISTITEMS.getName(), () => item.artistItems ?? []);
    form.putIfAbsent(FieldsEnum.AIRDAYS.getName(), () => []);
    form.putIfAbsent(FieldsEnum.GENRES.getName(), () => item.genres ?? []);
    form.putIfAbsent(FieldsEnum.TAGS.getName(), () => item.tags ?? []);
    form.putIfAbsent(
        FieldsEnum.LOCKEDFIELDS.getName(), () => item.lockedFields ?? []);
    form.putIfAbsent(
        FieldsEnum.PROVIDERIDS.getName(), () => item.providerIds ?? []);
  }
}
