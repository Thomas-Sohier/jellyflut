enum BookExtensions {
  CBA('.cba'),
  CBR('.cbr'),
  CBT('.cbt'),
  CBZ('.cbz'),
  CB7('.cb7'),
  EPUB('.epub');

  final String fileExtension;
  const BookExtensions(this.fileExtension);

  static BookExtensions fromString(String extension) {
    return BookExtensions.values.firstWhere((ext) => ext.fileExtension.toLowerCase() == extension.toLowerCase());
  }
}
