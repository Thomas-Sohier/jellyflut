import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_tabs_state.dart';

class HomeTabsCubit extends Cubit<HomeTabsState> {
  HomeTabsCubit() : super(HomeTabsState());

  void addHomeTabController(final Key key, final HomeTabController homeTabController) {
    emit(state.copyWith(status: Status.loading));
    emit(state
        .copyWith(homeTabControllers: {...state.homeTabControllers, key: homeTabController}, status: Status.success));
  }

  void setCurrentHomeTabController(final Key key) {
    emit(state.copyWith(status: Status.loading));
    emit(state.copyWith(currentHomeTabControllerKey: key, status: Status.success));
  }
}
