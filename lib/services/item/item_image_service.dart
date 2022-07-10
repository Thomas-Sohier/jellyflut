import 'package:jellyflut/globals.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ItemImageService {
  // Helper method to generate an URL to get Item image
  ///
  /// * [maxWidth]            => The maximum image width to return.
  /// * [maxHeight]           => The maximum image height to return.
  /// * [width]               => The fixed image width to return.
  /// * [height]              => The fixed image height to return.
  /// * [quality]             => Quality setting, from 0-100. Defaults to 90 and should suffice in most cases.
  /// * [fillWidth]           => Width of box to fill.
  /// * [fillHeight]          => Height of box to fill.
  /// * [tag]                 => Supply the cache tag from the item object to receive strong caching headers.
  /// * [format]              => The MediaBrowser.Model.Drawing.ImageFormat of the returned image.
  /// * [addPlayedIndicator]  => Add a played indicator.
  /// * [percentPlayed]       =>  Percent to render for the percent played overlay.
  /// * [unplayedCount]       => Unplayed count overlay to render.
  /// * [blur]                => Blur image.
  /// * [backgroundColor]     => Apply a background color for transparent images.
  /// * [foregroundLayer]     =>  Apply a foreground layer on top of the image.
  /// * [imageIndex]          => Image index.
  static String getItemImageUrl({
    required String itemId,
    ImageType type = ImageType.Primary,
    int? maxWidth,
    int? maxHeight,
    int? width,
    int? height,
    int quality = 60,
    int? fillWidth,
    int? fillHeight,
    String? tag,
    String? format,
    bool? addPlayedIndicator,
    double? percentPlayed,
    int? unplayedCount,
    int? blur,
    String? backgroundColor,
    String? foregroundLayer,
    int? imageIndex,
  }) {
    final uri = Uri.parse('${server.url}/Items/$itemId/Images/${type.name}');
    final queryParams = <String, dynamic>{};
    queryParams.putIfAbsent('maxWidth', () => maxWidth);
    queryParams.putIfAbsent('maxHeight', () => maxHeight);
    queryParams.putIfAbsent('width', () => width);
    queryParams.putIfAbsent('height', () => height);
    queryParams.putIfAbsent('quality', () => quality);
    queryParams.putIfAbsent('fillWidth', () => fillWidth);
    queryParams.putIfAbsent('fillHeight', () => fillHeight);
    queryParams.putIfAbsent('tag', () => tag);
    queryParams.putIfAbsent('format', () => format);
    queryParams.putIfAbsent('addPlayedIndicator', () => addPlayedIndicator);
    queryParams.putIfAbsent('percentPlayed', () => percentPlayed);
    queryParams.putIfAbsent('unplayedCount', () => unplayedCount);
    queryParams.putIfAbsent('blur', () => blur);
    queryParams.putIfAbsent('backgroundColor', () => backgroundColor);
    queryParams.putIfAbsent('foregroundLayer', () => foregroundLayer);
    queryParams.putIfAbsent('foregroundLayer', () => foregroundLayer);
    queryParams.putIfAbsent('imageIndex', () => imageIndex);
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    return uri.replace(queryParameters: finalQueryParams).toString();
  }
}
