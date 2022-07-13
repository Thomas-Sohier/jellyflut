part of 'auth_bloc.dart';

enum AuthStatus { initial, submissionInProgress, submissionSuccess, submissionFailure }

enum AuthPage { serverPage, loginPage }

@immutable
class AuthState {
  final AuthStatus authStatus;
  final AuthPage authPage;
  final ServerDto server;
  final UserDto user;

  const AuthState(
      {this.authStatus = AuthStatus.initial,
      this.authPage = AuthPage.serverPage,
      this.server = ServerDto.empty,
      this.user = UserDto.empty});

  AuthState copyWith({AuthStatus? authStatus, AuthPage? authPage, ServerDto? server, UserDto? user}) {
    return AuthState(
        authPage: authPage ?? this.authPage,
        authStatus: authStatus ?? this.authStatus,
        server: server ?? this.server,
        user: user ?? this.user);
  }
}
