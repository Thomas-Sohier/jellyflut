import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/screens/auth/models/server_dto.dart';
import 'package:jellyflut/screens/auth/models/user_dto.dart';
import 'package:rxdart/subjects.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BehaviorSubject<String> errors = BehaviorSubject<String>();
  final AuthenticationRepository _authenticationRepository;

  AuthBloc({required AuthenticationRepository authenticationRepository, required bool authenticated})
      : _authenticationRepository = authenticationRepository,
        super(authenticated ? AuthState(authStatus: AuthStatus.authenticated) : AuthState()) {
    on<RequestAuth>(_login);
    on<AuthServerAdded>(_authServerAdded);
    on<BackToFirstForm>(_onFirstPageRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthError>((event, emit) => errors.add(event.error));
  }

  void _onFirstPageRequested(BackToFirstForm event, Emitter<AuthState> emit) {
    emit(state.copyWith(user: UserDto(username: event.username, password: event.password)));
    emit(state.copyWith(authPage: AuthPage.serverPage));
  }

  void _authServerAdded(AuthServerAdded event, Emitter<AuthState> emit) {
    emit(state.copyWith(server: event.server, authPage: AuthPage.loginPage));
  }

  void _login(RequestAuth event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(
          user: UserDto(username: event.username, password: event.password),
          authStatus: AuthStatus.authenticationInProgress));
      await _authenticationRepository.logIn(
        username: state.user.username,
        password: state.user.password,
        serverName: state.server.name,
        serverUrl: state.server.url,
      );
      emit(state.copyWith(authStatus: AuthStatus.authenticated));
    } catch (e) {
      log(e.toString());
      errors.add(e.toString());
      emit(state.copyWith(authStatus: AuthStatus.authenticationFailure));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.authenticationInProgress));
    await _authenticationRepository.logout();
    emit(state.copyWith(
        user: UserDto.empty, server: ServerDto.empty, authPage: AuthPage.serverPage, authStatus: AuthStatus.initial));
  }
}
