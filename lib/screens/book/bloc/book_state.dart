part of 'book_bloc.dart';

class BookState {}

/// Book is loading.
class BookLoadingState extends BookState {}

/// Book loaded.
class BookLoadedState extends BookState {
  final Widget bookView;
  BookLoadedState({required this.bookView});
}

/// Book loaded.
class BookErrorState extends BookState {
  final String error;

  BookErrorState({required this.error});
}
