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
import 'package:rxdart/rxdart.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ItemsRepository _itemsRepository;
  final AuthenticationRepository _authenticationRepository;
  final BehaviorSubject<bool> pinnedHeaderStream = BehaviorSubject.seeded(false);
  final ValueNotifier<ThemeData> theme = ValueNotifier(ThemeProvider()
      .getThemeData
      .copyWith(colorScheme: _generateDefaultColorScheme)
      .copyWith(textTheme: _generateDefaultTextTheme));

  // Useful only for default theme
  // Default app theme isn't really contrast friendly on details page with gradient background
  // These two getters allow to modify the current theme with correct contrasted theme
  // on gradient
  static ColorScheme get _generateDefaultColorScheme => ThemeProvider()
      .getThemeData
      .colorScheme
      .copyWith(onBackground: ThemeProvider().getThemeData.colorScheme.onSecondary);
  static TextTheme get _generateDefaultTextTheme =>
      t.Theme.generateTextThemeFromColor(ThemeProvider().getThemeData.colorScheme.onSecondary);

  /// Helper cache method
  /// generate cache colorkey from item and current user
  String spKey(String id) => 'colors-$id-$currentUserId';

  String get currentUserId => _authenticationRepository.currentUser.id;

  DetailsBloc(
      {required Item item,
      required ThemeData theme,
      required ItemsRepository itemsRepository,
      required AuthenticationRepository authenticationRepository,
      String? heroTag,
      ScreenLayout screenLayout = ScreenLayout.desktop})
      : _itemsRepository = itemsRepository,
        _authenticationRepository = authenticationRepository,
        super(DetailsState(item: item, theme: theme, heroTag: heroTag, screenLayout: screenLayout)) {
    on<DetailsInitRequested>(_onDetailsInitRequested);
    on<DetailsItemUpdate>(_onItemUpdate);
    on<DetailsScreenSizeChanged>(_onScreenLayoutChanged);
    on<DetailsUpdateSeedColor>(_onSeedColorUpdate);
    on<DetailsThemeUpdate>(_onThemeUpdate);
  }

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
    _screenLayoutChanged(event.screenLayout);
    emit(state.copyWith(screenLayout: event.screenLayout));
  }

  /// Update the theme of current details
  /// Do not fire an Event, any theme change is linked to [theme] ValueNotifier
  void _onSeedColorUpdate(DetailsUpdateSeedColor event, Emitter<DetailsState> emit) {
    final detailsTheme = t.Theme.generateThemeFromColors(event.colors[0], event.colors[1]);
    theme.value = detailsTheme;

    emit(state.copyWith(theme: detailsTheme));
  }

  void _onThemeUpdate(DetailsThemeUpdate event, Emitter<DetailsState> emit) {
    theme.value = event.theme;
    emit(state.copyWith(theme: event.theme));
  }

  void shrinkOffsetChanged(double shrinkOffset) {
    if (state.screenLayout == ScreenLayout.mobile) {
      if (shrinkOffset > 0) {
        pinnedHeaderStream.add(true);
      } else {
        pinnedHeaderStream.add(false);
      }
    }
  }

  void _screenLayoutChanged(ScreenLayout screenLayout) {
    if (screenLayout == ScreenLayout.desktop) {
      pinnedHeaderStream.add(false);
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
