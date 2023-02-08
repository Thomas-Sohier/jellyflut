part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  authenticationInProgress,
  authenticated,
  authenticationFailure;

  bool get isAuthenticated => this == authenticated;
}

enum AuthPage { serverPage, loginPage }

@immutable
class AuthState extends Equatable {
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

  @override
  List<Object?> get props => [authStatus, authPage, server, user];
}
