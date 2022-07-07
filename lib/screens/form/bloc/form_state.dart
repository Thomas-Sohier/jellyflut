part of 'form_bloc.dart';

enum FormStatus { initial, submitted, failure }

@immutable
class FormState<T> extends Equatable {
  final FormGroup form;
  final T value;
  final FormStatus formStatus;

  const FormState({required this.form, required this.value, this.formStatus = FormStatus.initial});

  FormState<T> copyWith({FormGroup? form, T? value, FormStatus? formStatus}) {
    return FormState(value: value ?? this.value, form: form ?? this.form, formStatus: formStatus ?? this.formStatus);
  }

  @override
  List<Object> get props => [form, formStatus];
}
