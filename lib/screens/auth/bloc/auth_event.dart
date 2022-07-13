part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

///Check auth state.
class CheckAuthState extends AuthEvent {}

// Server form is filled
class AuthServerAdded extends AuthEvent {
  final ServerDto server;

  AuthServerAdded(this.server);
}

// User form is filled
class AuthUserAdded extends AuthEvent {
  final UserDto user;

  AuthUserAdded(this.user);
}

/// Try to login user
class RequestAuth extends AuthEvent {
  final String username;
  final String password;

  RequestAuth({required this.username, required this.password});
}

/// Error handling.
class AuthError extends AuthEvent {
  AuthError(this.error);
  final String error;
}

class BackToFirstForm extends AuthEvent {}

/// Reset states to unauthenticated.
/// To be used when the timer runs out or user cancels authentication, for
/// example.
class ResetStates extends AuthEvent {}

/// Successfully authenticated.
class AuthSuccessful extends AuthEvent {
  AuthSuccessful(this.accessToken);

  final String accessToken;
}

/// LogOut the user.
class LogOut extends AuthEvent {}
