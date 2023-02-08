import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/providers/search/search_provider.dart';

void searchItemsFuture(String searchTerm, ItemsRepository itemsRepository) {
  final searchProvider = SearchProvider();
  searchProvider.clearSearchResult();

  final movies = itemsRepository.searchItems(searchTerm: searchTerm, includeItemTypes: 'Movie');
  searchProvider.addSearchResult('Movie', movies);
  final series = itemsRepository.searchItems(searchTerm: searchTerm, includeItemTypes: 'Series');
  searchProvider.addSearchResult('Series', series);
  final episode = itemsRepository.searchItems(searchTerm: searchTerm, includeItemTypes: 'Episode');
  searchProvider.addSearchResult('Episode', episode);
  final iptv = itemsRepository.searchItems(searchTerm: searchTerm, includeItemTypes: 'LiveTvProgram');
  searchProvider.addSearchResult('LiveTvProgram', iptv);
  final videos =
      itemsRepository.searchItems(searchTerm: searchTerm, excludeItemTypes: 'Movie,Episode', mediaTypes: 'Video');
  searchProvider.addSearchResult('Video', videos);
}
