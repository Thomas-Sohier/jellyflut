import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  late DetailsInfosFuture _d;
  ScreenLayout _screenLayout;
  final BehaviorSubject<bool> pinnedHeaderStream =
      BehaviorSubject.seeded(false);
  final BehaviorSubject<ThemeData> themeStream = BehaviorSubject();

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
      themeStream.add(event.theme);
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

  Future<void> _updateTheme(
      DetailsUpdateSeedColor event, Emitter<DetailsState> emit) async {
    final theme = Luminance.computeLuminance(event.seedColor);
    _d.theme = theme;
    themeStream.add(theme);
    emit(DetailsLoadedState(_d));
  }

  Future<bool> cacheSeedColor(final Color color) async {
    final sp = await SharedPreferences.getInstance();
    final item = await _d.item;
    return sp.setString(spKey(item), color.value.toString());
  }

  Future<bool> isSeedColorCached() async {
    final sp = await SharedPreferences.getInstance();
    final item = await _d.item;
    return sp.containsKey(spKey(item));
  }

  Future<Color> getCachedSeedColor() async {
    final sp = await SharedPreferences.getInstance();
    final item = await _d.item;
    final colorsAsString = sp.getString(spKey(item))!;
    return Color(int.parse(colorsAsString));
  }

  void getItemBackgroundColor(final Item item,
      {final bool cache = true}) async {
    // get seed color from sharedPref to prevent computation on remote image
    // to load faster and prevent future API call
    if (cache && await isSeedColorCached()) {
      return add(DetailsUpdateSeedColor(seedColor: await getCachedSeedColor()));
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
          final middleColor = Color.lerp(c[0], c[1], 0.5) ?? c[0];
          await cacheSeedColor(middleColor);
          add(DetailsUpdateSeedColor(seedColor: middleColor));
        }));
      }
    });
  }
}
