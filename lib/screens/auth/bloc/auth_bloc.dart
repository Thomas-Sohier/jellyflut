import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:rxdart/subjects.dart';
import 'package:jellyflut/globals.dart' as globals;
import 'package:sqlite_database/sqlite_database.dart';
import 'package:users_repository/users_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FToast fToast = FToast();
  final BehaviorSubject<String> errors = BehaviorSubject<String>();
  final UsersRepository _usersRepository;
  Server? server;
  String? username;
  String? userPassword;

  AuthBloc(this._usersRepository, {required bool authenticated, this.username, this.userPassword, this.server})
      : super(authenticated ? AuthenticationSuccessful() : AuthenticationUnauthenticated()) {
    on<RequestAuth>(login);
    on<AuthServerAdded>(authServerAdded);
    on<AuthSuccessful>((event, emit) => emit(AuthenticationSuccessful()));
    on<BackToFirstForm>((event, emit) => emit(AuthenticationFirstForm()));
    on<ResetStates>((event, emit) => emit(AuthenticationUnauthenticated()));
    on<LogOut>((event, emit) => emit(AuthenticationUnauthenticated()));
    on<AuthError>((event, emit) => errors.add(event.error));
  }

  void authServerAdded(AuthServerAdded event, Emitter<AuthState> emit) {
    server = event.server;
    globals.server = event.server;

    // Update repositories server endpoint
    final context = globals.customRouter.navigatorKey.currentContext!;
    context.read<ItemsRepository>().updateProperties(serverUrl: server!.url);
    context.read<UsersRepository>().updateProperties(serverUrl: server!.url);
    emit(AuthenticationServerAdded(server: event.server));
  }

  void login(RequestAuth event, Emitter<AuthState> emit) async {
    try {
      emit(AuthenticationInProgress());
      username = event.username;
      userPassword = event.password;
      final response = await _usersRepository.login(username: event.username, password: event.password);
      await AuthService.storeAccountData(event.username, server!, response, userPassword!);
      emit(AuthenticationSuccessful());
    } catch (e) {
      log(e.toString());
      errors.add(e.toString());
      emit(AuthenticationError(e.toString()));
    }
  }
}
