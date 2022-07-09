part of 'form_bloc.dart';

@immutable
abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object> get props => [];
}

class InitForm extends FormEvent {}

class FormSubmitted extends FormEvent {}

class ResetForm extends FormEvent {}
