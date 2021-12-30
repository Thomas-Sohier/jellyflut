import 'package:archive/archive.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ComicView extends StatelessWidget {
  final PageController controller;
  final PhotoViewController _photoViewController = PhotoViewController();
  final Archive archive;
  final Function(int currentPage, int nbPage) listener;

  ComicView(
      {Key? key,
      required this.controller,
      required this.archive,
      required this.listener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nbPages = archive.files.length;

    return Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            if (pointerSignal.scrollDelta.dy.isNegative) {
              final s = (_photoViewController.scale ?? 1) + 0.1;
              _photoViewController.updateMultiple(scale: s);
            } else {
              final s = (_photoViewController.scale ?? 1) - 0.1;
              _photoViewController.updateMultiple(scale: s);
            }
          }
        },
        child: PhotoViewGallery.builder(
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
                controller: _photoViewController,
                imageProvider: MemoryImage(content.toUint8List()),
                filterQuality: FilterQuality.high,
                initialScale: PhotoViewComputedScale.contained,
              );
            }));
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
