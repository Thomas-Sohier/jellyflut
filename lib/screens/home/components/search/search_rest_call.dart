import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/services/item/item_service.dart';

void searchItemsFuture(String searchTerm) {
  final searchProvider = SearchProvider();
  final results = <String, List<Item>>{};

  ItemService.searchItems(searchTerm: searchTerm, includeItemTypes: 'Movie')
      .then((value) {
    results.putIfAbsent('Movie', () => value.items);
    searchProvider.addSearchResult(results);
  });
  ItemService.searchItems(searchTerm: searchTerm, includeItemTypes: 'Series')
      .then((value) {
    results.putIfAbsent('Series', () => value.items);
    searchProvider.addSearchResult(results);
  });
  ItemService.searchItems(searchTerm: searchTerm, includeItemTypes: 'Episode')
      .then((value) {
    results.putIfAbsent('Episode', () => value.items);
    searchProvider.addSearchResult(results);
  });
  ItemService.searchItems(
          searchTerm: searchTerm, includeItemTypes: 'LiveTvProgram')
      .then((value) {
    results.putIfAbsent('LiveTvProgram', () => value.items);
    searchProvider.addSearchResult(results);
  });
  ItemService.searchItems(
          searchTerm: searchTerm,
          includeItemTypes: 'Movie,Episode',
          mediaTypes: 'Video')
      .then((value) {
    results.putIfAbsent('Movie,Episode', () => value.items);
    searchProvider.addSearchResult(results);
  });
}
