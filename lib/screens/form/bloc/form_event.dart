part of 'form_bloc.dart';

abstract class FormEvent<T> {
  const FormEvent();
}

class EmailChanged<T> extends FormEvent<T> {
  const EmailChanged({required this.email});

  final String email;
}

class EmailUnfocused extends FormEvent {}

class PasswordChanged extends FormEvent {
  const PasswordChanged({required this.password});

  final String password;
}

class PasswordUnfocused<T> extends FormEvent<T> {}

class CurrentForm<T> extends FormEvent<T> {
  const CurrentForm({required this.formGroup, required this.value});

  final FormGroup formGroup;
  final T value;
}

class FormSubmitted<T> extends FormEvent<T> {}

class RefreshForm<T> extends FormEvent<T> {}
