import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:jellyflut/shared/shared_prefs.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/theme.dart' as t;
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:rxdart/rxdart.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  late DetailsInfosFuture _d;
  ScreenLayout _screenLayout;
  final BehaviorSubject<bool> pinnedHeaderStream =
      BehaviorSubject.seeded(false);
  final ValueNotifier<ThemeData> theme = ValueNotifier(ThemeProvider()
      .getThemeData
      .copyWith(colorScheme: _generateDefaultColorScheme)
      .copyWith(textTheme: _generateDefaultTextTheme));

  // Useful only for default theme
  // Default app theme isn't really contrast friendly on details page with gradient background
  // These two getters allow to modify the current theme with correct contrasted theme
  // on gradient
  static ColorScheme get _generateDefaultColorScheme =>
      ThemeProvider().getThemeData.colorScheme.copyWith(
          onBackground: ThemeProvider().getThemeData.colorScheme.onSecondary);
  static TextTheme get _generateDefaultTextTheme =>
      t.Theme.generateTextThemeFromColor(
          ThemeProvider().getThemeData.colorScheme.onSecondary);

  /// Helper cache method
  /// generate cache colorkey from item and current user
  String spKey(Item item) => 'colors-${item.id}-${userApp!.id}';

  DetailsInfosFuture get detailsInfos => _d;

  DetailsBloc(this._d, this._screenLayout) : super(DetailsLoadedState(_d)) {
    on<DetailsEvent>(_onEvent);
  }

  void _onEvent(DetailsEvent event, Emitter<DetailsState> emit) async {
    if (event is DetailsUpdateDetailsInfos) {
      _d = event.detailsInfos;
      emit(DetailsLoadedState(_d));
    } else if (event is DetailsUpdateItem) {
      _d.item = Future.value(event.item);
      emit(DetailsLoadedState(_d));
    } else if (event is DetailsScreenSizeChanged) {
      _screenLayoutChanged(event.screenLayout);
      emit(DetailsLoadedState(_d));
    } else if (event is DetailsUpdateSeedColor) {
      await _updateTheme(event, emit);
    } else if (event is DetailsUpdateTheme) {
      theme.value = event.theme;
      _d.theme = event.theme;
      emit(DetailsLoadedState(_d));
    }
  }

  void shrinkOffsetChanged(double shrinkOffset) {
    if (_screenLayout == ScreenLayout.mobile) {
      if (shrinkOffset > 0) {
        pinnedHeaderStream.add(true);
      } else {
        pinnedHeaderStream.add(false);
      }
    }
  }

  void _screenLayoutChanged(ScreenLayout screenLayout) {
    _screenLayout = screenLayout;
    if (screenLayout == ScreenLayout.desktop) {
      pinnedHeaderStream.add(false);
    }
  }

  /// Update the theme of current details
  /// Do not fire an Event, any theme change is linked to [theme] ValueNotifier
  Future<void> _updateTheme(
      DetailsUpdateSeedColor event, Emitter<DetailsState> emit) async {
    final detailsTheme =
        t.Theme.generateThemeFromColors(event.colors[0], event.colors[1]);
    _d.theme = detailsTheme;
    theme.value = detailsTheme;
  }

  Future<bool> cacheSeedColor(final List<Color> colors) async {
    final sp = SharedPrefs().sharedPrefs;
    final item = await _d.item;
    final colorsAsInt = colors.map((c) => c.value.toString());
    return sp.setStringList(spKey(item), colorsAsInt.toList());
  }

  Future<bool> isSeedColorCached() async {
    final sp = SharedPrefs().sharedPrefs;
    final item = await _d.item;
    return sp.containsKey(spKey(item));
  }

  Future<List<Color>> getCachedSeedColor() async {
    final sp = SharedPrefs().sharedPrefs;
    final item = await _d.item;
    final colorsAsString = sp.getStringList(spKey(item))!;
    return colorsAsString.map((c) => Color(int.parse(c))).toList();
  }

  void getItemBackgroundColor(final Item item,
      {final bool cache = true}) async {
    // get seed color from sharedPref to prevent computation on remote image
    // to load faster and prevent future API call
    if (cache && await isSeedColorCached()) {
      return add(DetailsUpdateSeedColor(colors: await getCachedSeedColor()));
    }

    final url = ItemImageService.getItemImageUrl(
        item.id, item.correctImageTags(searchType: ImageType.PRIMARY),
        type: item.correctImageType(searchType: ImageType.PRIMARY),
        quality: 40);

    await NetworkAssetBundle(Uri.parse(url))
        .load(url)
        .then((ByteData byteData) async {
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
