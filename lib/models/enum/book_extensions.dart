// \.[0-9a-z]+$

import 'enum_values.dart';

enum BookExtensions { CBZ, CBR, EPUB }

final bookExtensionsValues = EnumValues({
  '.cbz': BookExtensions.CBZ,
  '.cbr': BookExtensions.CBR,
  '.epub': BookExtensions.EPUB
});
