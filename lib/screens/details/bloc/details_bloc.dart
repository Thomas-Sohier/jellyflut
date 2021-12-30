import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  late DetailsInfosFuture _d;
  DetailsInfosFuture get detailsInfos => _d;

  DetailsBloc(this._d) : super(DetailsLoadedState(_d)) {
    on<DetailsEvent>(_onEvent);
  }

  void _onEvent(DetailsEvent event, Emitter<DetailsState> emit) async {
    if (event is DetailsUpdateDetailsInfos) {
      _d = event.detailsInfos;
      emit(DetailsLoadedState(_d));
    } else if (event is DetailsUpdateItem) {
      _d.item = Future.value(event.item);
      emit(DetailsLoadedState(_d));
    }
  }
}
