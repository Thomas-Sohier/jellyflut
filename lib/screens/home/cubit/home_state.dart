part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  HomeState(
      {this.status = HomeStatus.initial,
      this.parentItem,
      this.items = const <Item>[],
      this.routes = const <PageRouteInfo<dynamic>>[]});

  final HomeStatus status;
  final Item? parentItem;
  final List<Item> items;
  final List<PageRouteInfo<dynamic>> routes;

  HomeState copyWith({HomeStatus? status, List<Item>? items, Item? parentItem, List<PageRouteInfo<dynamic>>? routes}) {
    return HomeState(
      status: status ?? this.status,
      items: items ?? this.items,
      parentItem: parentItem ?? this.parentItem,
      routes: routes ?? this.routes,
    );
  }

  @override
  List<Object?> get props => [status, parentItem, items, routes];
}
