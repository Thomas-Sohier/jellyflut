part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  final bool authenticated = false;
}

/// User unauthenticated.
class AuthenticationUnauthenticated extends AuthState {}

/// Authentication initialized.
class AuthenticationServerAdded extends AuthState {
  final Server server;

  AuthenticationServerAdded({required this.server});
}

/// Authentication initialized.
class AuthenticationUserAdded extends AuthState {
  final User user;

  AuthenticationUserAdded({required this.user});
}

/// Authentication initialized.
class AuthenticationInitialized extends AuthState {
  final User user;
  final Server server;

  AuthenticationInitialized({required this.user, required this.server});
}

/// Authenticated.
class AuthenticationSuccessful extends AuthState {
  @override
  bool get authenticated => true;
}

class AuthenticationFirstForm extends AuthState {}

/// Error.
class AuthenticationError extends AuthState {
  AuthenticationError(this.error);
  final String error;
}
