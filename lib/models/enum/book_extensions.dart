// \.[0-9a-z]+$

import 'enum_values.dart';

enum BookExtensions { CBA, CBR, CBT, CBZ, CB7, EPUB }

final bookExtensionsValues = EnumValues({
  '.cba': BookExtensions.CBA,
  '.cbr': BookExtensions.CBR,
  '.cbt': BookExtensions.CBT,
  '.cbz': BookExtensions.CBZ,
  '.cb7': BookExtensions.CB7,
  '.epub': BookExtensions.EPUB
});
