import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  FormBloc() : super(FormState(form: FormGroup({})));

  @override
  Stream<FormState> mapEventToState(FormEvent event) async* {
    if (event is FormSubmitted) {
      // final email = Email.dirty(state.email.value);
      // final password = Password.dirty(state.password.value);
      // yield state.copyWith(
      //   email: email,
      //   password: password,
      //   status: Formz.validate([email, password]),
      // );
      // if (state.status.isValidated) {
      //   yield state.copyWith(status: FormzStatus.submissionInProgress);
      //   await Future<void>.delayed(const Duration(seconds: 1));
      //   yield state.copyWith(status: FormzStatus.submissionSuccess);
      // }
    }
  }
}
