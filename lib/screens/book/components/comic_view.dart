import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ComicView extends StatelessWidget {
  final PageController controller;
  final Archive archive;
  final Function(int currentPage, int nbPage) listener;
  const ComicView(
      {Key? key,
      required this.controller,
      required this.archive,
      required this.listener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nbPages = archive.files.length;

    return PhotoViewGallery.builder(
        itemCount: nbPages,
        enableRotation: false,
        gaplessPlayback: true,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) => listener(index, nbPages),
        pageController: controller,
        builder: (context, index) {
          final content =
              archive.files.elementAt(index).rawContent as InputStream;
          return PhotoViewGalleryPageOptions(
            imageProvider: MemoryImage(content.toUint8List()),
            filterQuality: FilterQuality.high,
            initialScale: PhotoViewComputedScale.contained,
          );
        });
  }

  double viewportFractionBasedOnScreen(BuildContext context) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    if (deviceType == DeviceScreenType.mobile) {
      return 1;
    } else if (deviceType == DeviceScreenType.tablet) {
      return 0.6;
    } else if (deviceType == DeviceScreenType.desktop) {
      return 0.4;
    }
    return 0.8;
  }
}
