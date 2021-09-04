part of 'form_bloc.dart';

class FormState extends Equatable {
  final FormGroup form;

  const FormState({required this.form});

  @override
  List<Object> get props => [];
}

class FormMovieState extends FormState {
  final String name;

  const FormMovieState({required this.name, required FormGroup form})
      : super(form: form);

  FormMovieState copyWith({String? name}) {
    return FormMovieState(name: name ?? this.name, form: form);
  }

  @override
  List<Object> get props => [];
}
