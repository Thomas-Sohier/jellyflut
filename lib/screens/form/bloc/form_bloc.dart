import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/form/bloc/form_builder/form_builder.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final ItemsRepository _itemsRepository;

  FormBloc({required ItemsRepository itemsRepository, required Item item})
      : _itemsRepository = itemsRepository,
        super(FormState(formBuilder: InitialFormBuilder(item: item), item: item)) {
    on<InitForm>(_initForm);
    on<FormSubmitted>(_submitForm);
    on<ResetForm>(_resetForm);
  }

  void _initForm(InitForm event, Emitter<FormState> emit) {
    emit(state.copyWith(formStatus: FormStatus.loading));
    late final FormBuilder formBuilder;
    switch (state.item.type) {
      case ItemType.Movie:
        formBuilder = MovieFormBuilder(item: state.item);
        break;
      default:
        formBuilder = InitialItemFormBuilder(item: state.item);
    }
    emit(state.copyWith(formBuilder: formBuilder, formStatus: FormStatus.loaded));
  }

  void _resetForm(ResetForm event, Emitter<FormState> emit) {
    emit(state.copyWith(formBuilder: InitialFormBuilder(item: state.item), formStatus: FormStatus.loaded));
  }

  Future<void> _submitForm(FormSubmitted event, Emitter<FormState> emit) async {
    state.formBuilder.formGroup.markAllAsTouched();
    if (state.formBuilder.formGroup.valid) {
      return _submitItemForm(emit);
    }
  }

  Future<void> _submitItemForm(Emitter<FormState> emit) {
    return _itemsRepository
        .updateItem(item: state.formBuilder.formToItem())
        .then((_) => emit(state.copyWith(formStatus: FormStatus.submitted)))
        .onError((_, __) => emit(state.copyWith(formStatus: FormStatus.failure)));
  }
}
