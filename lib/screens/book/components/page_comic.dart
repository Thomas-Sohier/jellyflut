import 'package:archive/archive.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:octo_image/octo_image.dart';

class PageComic extends StatelessWidget {
  final ArchiveFile archive;
  const PageComic({Key? key, required this.archive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFile = archive.isFile;
    if (isFile) {
      final content = archive.rawContent as InputStream;
      return OctoImage(
          image: MemoryImage(content.toUint8List()),
          fadeInDuration: Duration(milliseconds: 300),
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (context, _, stacktrace) =>
              Center(child: Text('cannot_load_page'.tr())),
          alignment: Alignment.center);
    }
    return Text(archive.name);
  }
}
