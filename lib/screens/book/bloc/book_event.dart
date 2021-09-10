part of 'book_bloc.dart';

@immutable
abstract class BookEvent {}

// Book is loading
class BookLoading extends BookEvent {}

// Server form is filled
class BookLoaded extends BookEvent {
  final Widget bookView;

  BookLoaded({required this.bookView});
}

/// Error handling.
class BookLoadingError extends BookEvent {
  final String error;

  BookLoadingError(this.error);
}

/// Reset states to no book loaded
class ResetStates extends BookEvent {}
