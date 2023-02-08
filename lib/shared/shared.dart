import 'package:jellyflut_models/jellyflut_models.dart';

double aspectRatio({ItemType? type}) {
  if (type == ItemType.MusicAlbum || type == ItemType.Audio) {
    return 1 / 1;
  } else if (type == ItemType.Photo) {
    return 4 / 3;
  } else if (type == ItemType.Episode) {
    return 16 / 9;
  } else if (type == ItemType.TvChannel || type == ItemType.TvProgram) {
    return 16 / 9;
  }
  return 2 / 3;
}

double parentAspectRatio({ItemType? type}) {
  if (type == ItemType.MusicAlbum || type == ItemType.Audio) {
    return 1 / 1;
  } else if (type == ItemType.Photo) {
    return 4 / 3;
  } else if (type == ItemType.Episode) {
    return 2 / 3;
  } else if (type == ItemType.TvChannel || type == ItemType.TvProgram) {
    return 16 / 9;
  }
  return 2 / 3;
}

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0) {
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

String removeAllHtmlTags(String htmlText) {
  var exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}
