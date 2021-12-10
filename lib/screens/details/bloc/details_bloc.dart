import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final _itemController = StreamController<Item>();
  Stream<Item> get itemStream => _itemController.stream;

  DetailsBloc() : super(DetailsLoadedState());

  @override
  Stream<DetailsState> mapEventToState(
    DetailsEvent event,
  ) async* {
    if (event is DetailsItemUpdated) {
      _itemController.add(event.item);
    }
  }
}
