part of 'form_bloc.dart';

abstract class FormEvent {
  const FormEvent();
}

class EmailChanged extends FormEvent {
  const EmailChanged({required this.email});

  final String email;
}

class EmailUnfocused extends FormEvent {}

class PasswordChanged extends FormEvent {
  const PasswordChanged({required this.password});

  final String password;
}

class PasswordUnfocused extends FormEvent {}

class FormSubmitted extends FormEvent {}
