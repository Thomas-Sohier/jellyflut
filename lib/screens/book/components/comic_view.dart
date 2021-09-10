import 'package:archive/archive.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/book/components/page_comic.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ComicView extends StatelessWidget {
  final CarouselController controller;
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

    return InteractiveViewer(
        maxScale: 4,
        minScale: 0.8,
        child: Center(
          child: CarouselSlider.builder(
              itemCount: nbPages,
              carouselController: controller,
              options: CarouselOptions(
                autoPlay: false,
                height: double.maxFinite,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                onPageChanged: (int i, _) => listener(i, nbPages),
                scrollDirection: Axis.horizontal,
                viewportFraction: viewportFractionBasedOnScreen(context),
              ),
              itemBuilder: (context, int index, _) {
                return PageComic(archive: archive.files.elementAt(index));
              }),
        ));
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
