part of 'form_bloc.dart';

@immutable
abstract class FormState<T> extends Equatable {
  final FormGroup form;

  const FormState({required this.form});

  @override
  List<Object> get props => [form];
}

class FormSubmittedState<T extends Object> extends FormState<T> {
  final String message;
  final T value;

  FormSubmittedState(
      {required this.message, required this.value, required super.form});

  @override
  List<Object> get props => [message, value];
}

class FormErrorState<T> extends FormState<T> {
  final String error;

  FormErrorState({required this.error, required super.form});
}

class RefreshedState<T> extends FormState<T> {
  RefreshedState({required super.form});
}
