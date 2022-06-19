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
import 'package:jellyflut/theme.dart' as personnal_theme;
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

  DetailsInfosFuture get detailsInfos => _d;

  DetailsBloc(this._d, this._screenLayout) : super(DetailsLoadedState()) {
    on<DetailsEvent>(_onEvent);
  }

  void _onEvent(DetailsEvent event, Emitter<DetailsState> emit) async {
    if (event is DetailsUpdateDetailsInfos) {
      _d = event.detailsInfos;
      emit(DetailsLoadedState());
    } else if (event is DetailsUpdateItem) {
      _d.item = Future.value(event.item);
      emit(DetailsLoadedState());
    } else if (event is DetailsScreenSizeChanged) {
      _screenLayoutChanged(event.screenLayout);
      emit(DetailsLoadedState());
    } else if (event is DetailsUpdateColor) {
      await _updateTheme(event, emit);
    } else if (event is DetailsUpdateTheme) {
      themeStream.add(event.theme);
      _d.theme = event.theme;
      emit(DetailsLoadedState());
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
      DetailsUpdateColor event, Emitter<DetailsState> emit) async {
    final colors = event.colors;
    _d.dominantColor.add(colors);

    return await event.colors.then((List<Color> c) {
      if (c.isNotEmpty) {
        final middleColor = Color.lerp(c[0], c[1], 0.5) ?? c[0];
        final theme = Luminance.computeLuminance(middleColor);
        _d.theme = theme;
        themeStream.add(theme);
        emit(DetailsLoadedState());
      }
    });
  }

  void getItemBackgroundColor(final Item item,
      {final bool cache = true}) async {
    final sp = await SharedPreferences.getInstance();
    final spKey = 'colors-${item.id}-${userApp!.id}';

    // save binary in sharedpref to load faster and prevent future API call
    if (cache && sp.containsKey(spKey)) {
      final colorsAsString = sp.getStringList(spKey)!;
      final colors = colorsAsString.map((c) => Color(int.parse(c))).toList();
      return add(DetailsUpdateColor(colors: Future.value(colors)));
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
        unawaited(colorsFuture.then((colors) async {
          final colorsInt = colors.map((c) => c.value.toString()).toList();
          await sp.setStringList(spKey, colorsInt);
        }));
      }
      add(DetailsUpdateColor(colors: colorsFuture));
    });
  }
}
