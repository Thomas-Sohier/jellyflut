part of 'form_bloc.dart';

class FormState {
  final FormGroup form;

  const FormState({required this.form});
}

class FormMovieState extends FormState {
  final String name;

  const FormMovieState({required this.name, required FormGroup form})
      : super(form: form);

  FormMovieState copyWith({String? name}) {
    return FormMovieState(name: name ?? this.name, form: form);
  }
}

/// Book loaded.
class FormErrorState extends FormState {
  final String error;

  FormErrorState({required this.error, required FormGroup form})
      : super(form: form);
}
