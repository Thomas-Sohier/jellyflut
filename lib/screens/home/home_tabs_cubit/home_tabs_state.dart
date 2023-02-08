part of 'home_tabs_cubit.dart';

enum Status { initial, loading, success, failure }

class HomeTabsState extends Equatable {
  HomeTabsState(
      {this.status = Status.initial,
      this.homeTabControllers = const <Key, HomeTabController>{},
      this.currentHomeTabControllerKey = const ValueKey('empty_key')});

  final Status status;
  final Map<Key, HomeTabController> homeTabControllers;
  final Key currentHomeTabControllerKey;

  HomeTabController? get currentHomeTabController => homeTabControllers[currentHomeTabControllerKey];

  List<Widget> get currentHomeTabControllerTabs =>
      homeTabControllers[currentHomeTabControllerKey]?.tabs ?? const <Tab>[];

  HomeTabsState copyWith(
      {Status? status, Map<Key, HomeTabController>? homeTabControllers, Key? currentHomeTabControllerKey}) {
    return HomeTabsState(
        status: status ?? this.status,
        homeTabControllers: homeTabControllers ?? this.homeTabControllers,
        currentHomeTabControllerKey: currentHomeTabControllerKey ?? this.currentHomeTabControllerKey);
  }

  @override
  List<Object?> get props => [status, currentHomeTabControllerKey, homeTabControllers];
}

class HomeTabController {
  final List<Widget> tabs;
  final TabController? tabController;

  const HomeTabController({required this.tabs, required this.tabController});

  static const HomeTabController empty = HomeTabController(tabController: null, tabs: []);

  /// Convenience getter to determine whether the current controller is empty.
  bool get isEmpty => this == HomeTabController.empty;

  /// Convenience getter to determine whether the current controller is not empty.
  bool get isNotEmpty => this != HomeTabController.empty;
}
