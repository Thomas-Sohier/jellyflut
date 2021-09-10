import 'package:carousel_slider/carousel_slider.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/book/components/page_epub.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EpubView extends StatelessWidget {
  final CarouselController controller;
  final EpubBook epubBook;
  final Function(int currentPage, int nbPage) listener;
  const EpubView(
      {Key? key,
      required this.controller,
      required this.epubBook,
      required this.listener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nbPages = epubBook.Content?.Html?.values.length ?? 0;
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
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
            itemBuilder: (context, index, _) {
              return PageEpub(
                  content: epubBook.Content?.Html?.values.elementAt(index));
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
