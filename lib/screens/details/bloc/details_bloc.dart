import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/shared/color_palette_service.dart';
import 'package:jellyflut/theme/theme.dart' as t;
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ItemsRepository _itemsRepository;
  final AuthenticationRepository _authenticationRepository;
  final DownloadsRepository _downloadsRepository;
  final ThemeProvider _themeProvider;
  final ColorPaletteService _colorPaletteService;

  DetailsBloc({
    required Item item,
    required ItemsRepository itemsRepository,
    required AuthenticationRepository authenticationRepository,
    required DownloadsRepository downloadsRepository,
    required ThemeProvider themeProvider,
    required SharedPreferences sharedPreferences,
    bool contrastedPage = false,
    String? heroTag,
  }) : _itemsRepository = itemsRepository,
       _authenticationRepository = authenticationRepository,
       _downloadsRepository = downloadsRepository,
       _themeProvider = themeProvider,
       _colorPaletteService = ColorPaletteService(
         sharedPreferences: sharedPreferences,
         imageUrl: itemsRepository.getItemImageUrl(
           itemId: item.id,
           tag: item.correctImageTags(searchType: ImageType.Primary),
           type: item.correctImageType(searchType: ImageType.Primary),
           quality: 40,
         ),
       ),
       super(
         DetailsState(item: item, contrastedPage: contrastedPage, theme: themeProvider.getThemeData, heroTag: heroTag),
       ) {
    on<DetailsInitRequested>(_onDetailsInitRequested);
    on<DetailsItemUpdate>(_onItemUpdate);
    on<DetailsUpdateSeedColor>(_onSeedColorUpdate);
  }

  /// Helper cache method
  /// generate cache colorkey from item and current user
  String spKey(String id) => 'colors-$id-$currentUserId';

  String get currentUserId => _authenticationRepository.currentUser.id;

  void _onDetailsInitRequested(DetailsInitRequested event, Emitter<DetailsState> emit) async {
    emit(state.copyWith(item: event.item, detailsStatus: DetailsStatus.loading));

    final results = await Future.wait([_fetchItemDetails(event.item.id), _fetchPaletteAndUpdateTheme(event.item)]);

    final itemDetails = results[0] as Item?;

    if (itemDetails != null) {
      emit(state.copyWith(item: itemDetails, detailsStatus: DetailsStatus.success));
    } else {
      emit(state.copyWith(detailsStatus: DetailsStatus.failure));
    }
  }

  Future<Item> _fetchItemDetails(String id) async {
    final item = await _downloadsRepository.getItemFromStorage(itemId: id);
    if (item.isNotEmpty || offlineMode) {
      return item;
    } else {
      return _itemsRepository.getItem(id);
    }
  }

  void _onItemUpdate(DetailsItemUpdate event, Emitter<DetailsState> emit) {
    emit(state.copyWith(item: event.item, detailsStatus: DetailsStatus.success));
  }

  /// Update the theme of current details
  void _onSeedColorUpdate(DetailsUpdateSeedColor event, Emitter<DetailsState> emit) {
    final detailsTheme = t.Theme.generateDetailsThemeDataFromPaletteColor(
      event.colors,
      state.contrastedPage,
      _themeProvider.getThemeData.brightness,
    );
    emit(state.copyWith(theme: detailsTheme));
  }

  Future<void> _fetchPaletteAndUpdateTheme(Item item) async {
    final colors = await _colorPaletteService.getPalette(item);
    if (colors.isNotEmpty && !isClosed) {
      // On utilise `add` pour émettre un nouvel état avec le thème
      add(DetailsUpdateSeedColor(colors: colors));
    }
  }
}
