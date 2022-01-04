part of 'collection_bloc.dart';

class CollectionState {}

/// Book is loading.
class CollectionLoadingState extends CollectionState {}

/// Book loaded.
class CollectionLoadedState extends CollectionState {
  CollectionLoadedState();
}

/// Book loaded.
class CollectionErrorState extends CollectionState {
  final String error;

  CollectionErrorState({required this.error});
}
