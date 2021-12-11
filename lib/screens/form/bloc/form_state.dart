part of 'form_bloc.dart';

class FormState<T> {
  final FormGroup form;

  const FormState({required this.form});
}

class FormValidState<T> extends FormState<T> {
  final String message;
  final T value;

  FormValidState(
      {required this.message, required this.value, required FormGroup form})
      : super(form: form);
}

class FormErrorState<T> extends FormState<T> {
  final String error;

  FormErrorState({required this.error, required FormGroup form})
      : super(form: form);
}

class RefreshedState<T> extends FormState<T> {
  RefreshedState({required FormGroup form}) : super(form: form);
}
