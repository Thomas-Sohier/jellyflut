import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:rxdart/subjects.dart';
import 'package:jellyflut/globals.dart' as globals;
import 'package:sqlite_database/sqlite_database.dart';

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
            : AuthenticationUnauthenticated()) {
    on<RequestAuth>(login);
    on<AuthServerAdded>((event, emit) {
      server = event.server;
      emit(AuthenticationServerAdded(server: event.server));
    });
    on<AuthSuccessful>((event, emit) => emit(AuthenticationSuccessful()));
    on<BackToFirstForm>((event, emit) => emit(AuthenticationFirstForm()));
    on<ResetStates>((event, emit) => emit(AuthenticationUnauthenticated()));
    on<LogOut>((event, emit) => emit(AuthenticationUnauthenticated()));
    on<AuthError>((event, emit) => errors.add(event.error));
  }

  void login(RequestAuth event, Emitter<AuthState> emit) async {
    try {
      emit(AuthenticationInProgress());
      username = event.username;
      userPassword = event.password;
      globals.server = server!;
      final response = await AuthService.login(event.username, event.password);
      await AuthService.storeAccountData(
          event.username, server!, response, userPassword!);
      emit(AuthenticationSuccessful());
    } catch (e) {
      log(e.toString());
      errors.add(e.toString());
      emit(AuthenticationError(e.toString()));
    }
  }
}
