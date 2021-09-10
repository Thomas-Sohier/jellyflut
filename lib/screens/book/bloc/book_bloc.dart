import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(BookState());

  @override
  Stream<BookState> mapEventToState(
    BookEvent event,
  ) async* {
    if (event is BookLoading) {
      yield BookLoadingState();
    } else if (event is BookLoaded) {
      yield BookLoadedState(bookView: event.bookView);
    } else if (event is BookLoadingError) {
      yield BookErrorState(error: event.error);
    }
  }
}
