import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:rxdart/subjects.dart';
import 'package:jellyflut/globals.dart' as globals;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FToast fToast = FToast();
  final BehaviorSubject<String> errors = BehaviorSubject<String>();
  Server? server;
  String? username;
  String? userPassword;

  AuthBloc(
      {required bool authenticated,
      this.username,
      this.userPassword,
      this.server})
      : super(authenticated
            ? AuthenticationSuccessful()
            : AuthenticationUnauthenticated());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is RequestAuth) {
      username = event.username;
      userPassword = event.password;
      yield* _mapLoginToState(event);
    } else if (event is AuthServerAdded) {
      server = event.server;
      yield AuthenticationServerAdded(server: event.server);
    } else if (event is AuthSuccessful) {
      yield AuthenticationSuccessful();
    } else if (event is BackToFirstForm) {
      yield AuthenticationFirstForm();
    } else if (event is ResetStates || event is LogOut) {
      yield AuthenticationUnauthenticated();
    } else if (event is AuthError) {
      errors.add(event.error);
    }
  }

  Stream<AuthState> _mapLoginToState(RequestAuth event) async* {
    try {
      globals.server = server!;
      final response = await AuthService.login(event.username, event.password);
      await AuthService.storeAccountData(event.username, response);
      yield AuthenticationSuccessful();
    } catch (e) {
      errors.add(e.toString());
    }
  }
}
