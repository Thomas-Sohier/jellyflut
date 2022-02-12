import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/services/item/item_service.dart';

void searchItemsFuture(String searchTerm) {
  final searchProvider = SearchProvider();
  searchProvider.clearSearchResult();

  final movies = ItemService.searchItems(
      searchTerm: searchTerm, includeItemTypes: 'Movie');
  searchProvider.addSearchResult('Movie', movies);
  final series = ItemService.searchItems(
      searchTerm: searchTerm, includeItemTypes: 'Series');
  searchProvider.addSearchResult('Series', series);
  final episode = ItemService.searchItems(
      searchTerm: searchTerm, includeItemTypes: 'Episode');
  searchProvider.addSearchResult('Episode', episode);
  final iptv = ItemService.searchItems(
      searchTerm: searchTerm, includeItemTypes: 'LiveTvProgram');
  searchProvider.addSearchResult('LiveTvProgram', iptv);
  final videos = ItemService.searchItems(
      searchTerm: searchTerm,
      excludeItemTypes: 'Movie,Episode',
      mediaTypes: 'Video');
  searchProvider.addSearchResult('Video', videos);
}
