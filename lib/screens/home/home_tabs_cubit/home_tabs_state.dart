part of 'home_tabs_cubit.dart';

enum Status { initial, loading, success, failure }

class HomeTabsState extends Equatable {
  HomeTabsState({this.status = Status.initial, this.tabs = const <Widget>[], this.tabController});

  final Status status;
  final List<Widget> tabs;
  final TabController? tabController;

  HomeTabsState copyWith({Status? status, List<Widget>? tabs, TabController? tabController}) {
    return HomeTabsState(status: status ?? this.status, tabs: tabs ?? this.tabs, tabController: tabController);
  }

  @override
  List<Object?> get props => [status, tabs, tabController];
}
