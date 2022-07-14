part of 'home_category_cubit.dart';

enum HomeCategoryStatus { initial, loading, success, failure }

enum HomeCategoryType {
  latest('latest'),
  resume('resume'),
  item('item');

  const HomeCategoryType(this.title);
  final String title;
}

class HomeCategoryState extends Equatable {
  HomeCategoryState(
      {this.status = HomeCategoryStatus.initial,
      this.parentItem,
      this.items = const <Item>[],
      this.type = HomeCategoryType.item});

  final HomeCategoryStatus status;
  final HomeCategoryType type;
  final Item? parentItem;
  final List<Item> items;

  HomeCategoryState copyWith(
      {HomeCategoryStatus? status, List<Item>? items, Item? parentItem, HomeCategoryType? type}) {
    return HomeCategoryState(
        status: status ?? this.status,
        items: items ?? this.items,
        parentItem: parentItem ?? this.parentItem,
        type: type ?? this.type);
  }

  String get categoryName {
    if (parentItem == null) {
      return type.title;
    }
    return parentItem!.name ?? '';
  }

  @override
  List<Object?> get props => [status, type, parentItem, items];
}
