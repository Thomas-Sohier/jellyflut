part of 'form_bloc.dart';

@immutable
abstract class FormEvent<T> extends Equatable {
  const FormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged<T> extends FormEvent<T> {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class EmailUnfocused extends FormEvent {}

class PasswordChanged extends FormEvent {
  const PasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswordUnfocused<T> extends FormEvent<T> {}

class UpdateForm<T extends Object> extends FormEvent<T> {
  final FormGroup formGroup;
  const UpdateForm({required this.formGroup});

  @override
  List<Object> get props => [formGroup];
}

class FormSubmitted<T> extends FormEvent<T> {}

class ResetForm<T> extends FormEvent<T> {}
