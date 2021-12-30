import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(BookState()) {
    on<BookLoading>((event, emit) => BookLoadingState);
    on<BookLoaded>((event, emit) => BookLoadedState(bookView: event.bookView));
    on<BookLoadingError>((event, emit) => BookErrorState(error: event.error));
  }
}
