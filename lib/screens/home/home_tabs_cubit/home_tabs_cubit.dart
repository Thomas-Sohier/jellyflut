import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_tabs_state.dart';

class HomeTabsCubit extends Cubit<HomeTabsState> {
  HomeTabsCubit() : super(HomeTabsState());

  void setTabs(final List<Widget> tabs, TabController? tabController) {
    emit(state.copyWith(tabs: tabs, tabController: tabController, status: Status.loading));
    emit(state.copyWith(tabs: tabs, tabController: tabController, status: Status.success));
  }
}
