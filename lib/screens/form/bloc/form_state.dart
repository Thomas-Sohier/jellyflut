part of 'form_bloc.dart';

enum FormStatus { loading, loaded, submitted, failure }

@immutable
class FormState extends Equatable {
  final FormBuilder formBuilder;
  final FormStatus formStatus;
  final Item item;

  const FormState({required this.formBuilder, required this.item, this.formStatus = FormStatus.loading});

  FormState copyWith({FormBuilder? formBuilder, Item? item, FormStatus? formStatus}) {
    return FormState(
        item: item ?? this.item,
        formBuilder: formBuilder ?? this.formBuilder,
        formStatus: formStatus ?? this.formStatus);
  }

  @override
  List<Object> get props => [formBuilder, item, formStatus];
}
