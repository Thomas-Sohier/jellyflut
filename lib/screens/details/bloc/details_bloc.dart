import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  late DetailsInfosFuture _d;
  final BehaviorSubject<List<Color>> gradientStream = BehaviorSubject();

  DetailsInfosFuture get detailsInfos => _d;

  DetailsBloc(this._d) : super(DetailsLoadedState(_d)) {
    on<DetailsEvent>(_onEvent);
  }

  void _onEvent(DetailsEvent event, Emitter<DetailsState> emit) async {
    if (event is DetailsUpdateDetailsInfos) {
      _d = event.detailsInfos;
      emit(DetailsLoadedState(_d));
    } else if (event is DetailsUpdateItem) {
      _d.item = Future.value(event.item);
      emit(DetailsLoadedState(_d));
    } else if (event is DetailsUpdateColor) {
      _d.dominantColor.add(event.colors);
      await event.colors.then((value) => gradientStream.add(value));
    }
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
