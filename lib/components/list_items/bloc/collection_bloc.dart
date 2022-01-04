import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart' as model;
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';
import 'package:rxdart/rxdart.dart';

part 'collection_event.dart';
part 'collection_state.dart';

/// A `CollectionBloc` which manages an `List<Item>` as its state.
class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  late Item parentItem;
  final List<Item> carouselSliderItems = <Item>[];
  final List<Item> items = <Item>[];
  final BehaviorSubject<ListType> listType = BehaviorSubject<ListType>()
    ..add(ListType.GRID);

  // Sorting by name
  bool _sortByNameASC = false;
  bool _sortByNameDSC = true;

  // Sorting by date
  bool _sortByDateASC = false;
  bool _sortByDateDSC = true;

  // Used to know if we should load another async method to fetch items
  // prevent from calling 1000 times API
  bool _blockItemsLoading = false;

  CollectionBloc() : super(CollectionLoadingState()) {
    on<AddItem>(addItems);
    on<LoadMoreItems>(showMoreItem);
    on<SortByName>(sortByName);
    on<SortByDate>(sortByDate);
  }

  void initialize(Item item) {
    parentItem = item;
    getItems(item: item)
        .then((model.Category category) => add(AddItem(items: category.items)));
  }

  void addItems(AddItem event, Emitter<CollectionState> emit) {
    emit(CollectionLoadingState());
    items.addAll(event.items);
    // Filter only unplayed items
    final unplayedItems =
        items.where((element) => !element.isPlayed()).toList();
    unplayedItems.shuffle();
    carouselSliderItems.addAll(event.items);
    emit(CollectionLoadedState());
  }

  void showMoreItem(LoadMoreItems event, Emitter<CollectionState> emit) async {
    if (!_blockItemsLoading && items.isNotEmpty) {
      _blockItemsLoading = true;
      final category =
          await getItems(item: parentItem, startIndex: items.length);
      if (category.items.isNotEmpty) {
        _blockItemsLoading = false;
        items.addAll(category.items);
        emit(CollectionLoadedState());
      }
    }
  }

  void sortByName(SortByName event, Emitter<CollectionState> emit) async {
    emit(CollectionLoadingState());
    final _items = await _sortByName();
    items.clear();
    items.addAll(_items);
    emit(CollectionLoadedState());
  }

  void sortByDate(SortByDate event, Emitter<CollectionState> emit) async {
    emit(CollectionLoadingState());
    final _items = await _sortByDate();
    items.clear();
    items.addAll(_items);
    emit(CollectionLoadedState());
  }

  Future<List<Item>> _sortByName() async {
    final i = await compute(_sortItemByName, {
      'items': items,
      'sortByNameASC': _sortByNameASC,
      'sortByNameDSC': _sortByNameDSC
    });
    _sortByNameASC = i['sortByNameASC'];
    _sortByNameDSC = i['sortByNameDSC'];
    return i['items'];
  }

  Future<List<Item>> _sortByDate() async {
    var i = await compute(_sortItemByDate, {
      'items': items,
      'sortByDateASC': _sortByDateASC,
      'sortByDateDSC': _sortByDateDSC
    });
    _sortByDateASC = i['sortByDateASC'];
    _sortByDateDSC = i['sortByDateDSC'];
    return i['items'];
  }

  Future<model.Category> getItems(
      {required Item item, int startIndex = 0}) async {
    return ItemService.getItems(
        parentId: item.id,
        sortBy: 'SortName',
        fields:
            'PrimaryImageAspectRatio,SortName,PrimaryImageAspectRatio,DateCreated,DateAdded,Overview',
        imageTypeLimit: 1,
        recursive: false,
        startIndex: startIndex,
        includeItemTypes: item
            .getCollectionType()
            .map((e) => e.getValue())
            .toList()
            .join(','),
        limit: 100);
  }
}

Map<String, dynamic> _sortItemByName(Map<String, dynamic> arg) {
  List<Item> items = arg['items'];
  bool sortByNameASC = arg['sortByNameASC'];
  bool sortByNameDSC = arg['sortByNameDSC'];
  if (!sortByNameASC || (!sortByNameASC && !sortByNameDSC)) {
    items.sort((a, b) => a.name.compareTo(b.name));
    sortByNameASC = true;
    sortByNameDSC = false;
  } else if (sortByNameASC) {
    items.sort((a, b) => b.name.compareTo(a.name));
    sortByNameASC = false;
    sortByNameDSC = true;
  }
  return {
    'items': items,
    'sortByNameASC': sortByNameASC,
    'sortByNameDSC': sortByNameDSC
  };
}

Map<String, dynamic> _sortItemByDate(Map<String, dynamic> arg) {
  List<Item> items = arg['items'];
  bool sortByDateASC = arg['sortByDateASC'];
  bool sortByDateDSC = arg['sortByDateDSC'];
  if (!sortByDateASC || (!sortByDateASC && !sortByDateDSC)) {
    items.sort((a, b) {
      if (a.dateCreated != null && b.dateCreated != null) {
        return a.dateCreated!.compareTo(b.dateCreated!);
      } else {
        return -1;
      }
    });
    sortByDateASC = true;
    sortByDateDSC = false;
  } else if (sortByDateASC) {
    items.sort((a, b) {
      if (a.dateCreated != null && b.dateCreated != null) {
        return b.dateCreated!.compareTo(a.dateCreated!);
      } else {
        return -1;
      }
    });
    sortByDateASC = false;
    sortByDateDSC = true;
  }
  return {
    'items': items,
    'sortByDateASC': sortByDateASC,
    'sortByDateDSC': sortByDateDSC
  };
}
