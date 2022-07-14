import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/shared/shared_prefs.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/theme.dart' as t;
import 'package:jellyflut_models/jellyflut_models.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ItemsRepository _itemsRepository;
  final AuthenticationRepository _authenticationRepository;

  DetailsBloc(
      {required Item item,
      required ItemsRepository itemsRepository,
      required AuthenticationRepository authenticationRepository,
      required ThemeProvider themeProvider,
      String? heroTag,
      ScreenLayout screenLayout = ScreenLayout.desktop})
      : _itemsRepository = itemsRepository,
        _authenticationRepository = authenticationRepository,
        super(DetailsState(
            item: item,
            theme: t.Theme.generateThemeFromColors(
                themeProvider.getThemeData.colorScheme.primary, themeProvider.getThemeData.colorScheme.secondary),
            heroTag: heroTag,
            screenLayout: screenLayout)) {
    on<DetailsInitRequested>(_onDetailsInitRequested);
    on<DetailsItemUpdate>(_onItemUpdate);
    on<PinnedHeaderChangeRequested>(_shrinkOffsetChanged);
    on<DetailsScreenSizeChanged>(_onScreenLayoutChanged);
    on<DetailsUpdateSeedColor>(_onSeedColorUpdate);
  }

  /// Helper cache method
  /// generate cache colorkey from item and current user
  String spKey(String id) => 'colors-$id-$currentUserId';

  String get currentUserId => _authenticationRepository.currentUser.id;

  void _onDetailsInitRequested(DetailsInitRequested event, Emitter<DetailsState> emit) async {
    emit(state.copyWith(item: event.item, detailsStatus: DetailsStatus.loading));
    if (offlineMode) {
      return emit(state.copyWith(item: event.item, detailsStatus: DetailsStatus.success));
    }
    _getItemBackgroundColor(event.item);
    final item = await _itemsRepository.getItem(event.item.id);
    return emit(state.copyWith(item: item, detailsStatus: DetailsStatus.success));
  }

  void _onItemUpdate(DetailsItemUpdate event, Emitter<DetailsState> emit) {
    emit(state.copyWith(item: event.item, detailsStatus: DetailsStatus.success));
  }

  void _onScreenLayoutChanged(DetailsScreenSizeChanged event, Emitter<DetailsState> emit) {
    if (event.screenLayout == ScreenLayout.desktop) {
      emit(state.copyWith(pinnedHeader: false));
    }
    emit(state.copyWith(screenLayout: event.screenLayout));
  }

  /// Update the theme of current details
  void _onSeedColorUpdate(DetailsUpdateSeedColor event, Emitter<DetailsState> emit) {
    final detailsTheme = t.Theme.generateThemeFromColors(event.colors[0], event.colors[1]);
    emit(state.copyWith(theme: detailsTheme));
  }

  void _shrinkOffsetChanged(PinnedHeaderChangeRequested event, Emitter<DetailsState> emit) {
    if (state.screenLayout == ScreenLayout.mobile) {
      if (event.shrinkOffset > 0) {
        emit(state.copyWith(pinnedHeader: true));
      } else {
        emit(state.copyWith(pinnedHeader: false));
      }
    }
  }

  Future<bool> cacheSeedColor(final List<Color> colors) async {
    final sp = SharedPrefs.sharedPrefs;
    final item = state.item;
    final colorsAsInt = colors.map((c) => c.value.toString());
    return sp.setStringList(spKey(item.id), colorsAsInt.toList());
  }

  bool isSeedColorCached() {
    final sp = SharedPrefs.sharedPrefs;
    final item = state.item;
    return sp.containsKey(spKey(item.id));
  }

  List<Color> getCachedSeedColor() {
    final sp = SharedPrefs.sharedPrefs;
    final item = state.item;
    final colorsAsString = sp.getStringList(spKey(item.id))!;
    return colorsAsString.map((c) => Color(int.parse(c))).toList();
  }

  void _getItemBackgroundColor(final Item item, {final bool cache = true}) async {
    // get seed color from sharedPref to prevent computation on remote image
    // to load faster and prevent future API call
    if (cache && isSeedColorCached()) {
      return add(DetailsUpdateSeedColor(colors: getCachedSeedColor()));
    }

    final url = _itemsRepository.getItemImageUrl(
        itemId: item.id,
        tag: item.correctImageTags(searchType: ImageType.Primary),
        type: item.correctImageType(searchType: ImageType.Primary),
        quality: 40);

    await NetworkAssetBundle(Uri.parse(url)).load(url).then((ByteData byteData) async {
      final imageBytes = byteData.buffer.asUint8List();
      final colorsFuture = compute(ColorUtil.extractPixelsColors, imageBytes);

      // save binary in sharedpref to load faster and prevent future API call
      if (cache) {
        unawaited(colorsFuture.then((c) async {
          await cacheSeedColor(c);
          add(DetailsUpdateSeedColor(colors: c));
        }));
      }
    });
  }
}
