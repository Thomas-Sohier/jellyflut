import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart' as g;
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/home/home_provider.dart';
import 'package:jellyflut/services/user/user_service.dart';
import 'package:jellyflut/theme.dart';
import 'package:shimmer/shimmer.dart';

class Latest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LatestState();
  }
}

const double gapSize = 20;
const double listViewHeight = 200;

class _LatestState extends State<Latest> {
  final String categoryTitle = 'latest';
  final double scalePosterSizeValue = 0.8;
  late Future<List<Item>> itemsFuture;
  late final HomeCategoryProvider homeCategoryprovider;

  @override
  void initState() {
    homeCategoryprovider = HomeCategoryProvider();
    checkIfCategoryInitialized();
    super.initState();
  }

  @override
  Widget build(Object context) {
    return categoryBuilder();
  }

  /// Prevent from re-query the API on resize
  Widget categoryBuilder() {
    return FutureBuilder<List<Item>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          var _items = snapshot.data!;
          if (_items.isNotEmpty) {
            return body(_items);
          } else {
            return const SizedBox();
          }
        }
        return placeholder();
      },
    );
  }

  Widget body(List<Item> items) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            'latest',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ).tr(),
        ),
        SizedBox(
            height: (itemPosterHeight + itemPosterLabelHeight) *
                scalePosterSizeValue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var _item = items[index];
                return ItemPoster(
                  _item,
                  width: double.infinity,
                  height: double.infinity,
                  showLogo: true,
                  imagefilter: true,
                  tag: ImageType.BACKDROP,
                  widgetAspectRatio: 16 / 9,
                );
              },
            ))
      ],
    );
  }

  Widget placeholder() {
    return Shimmer.fromColors(
        enabled: g.shimmerAnimation,
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                    height: 30,
                    width: 70,
                    color: Colors.white30,
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 8, 4),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: Container(
                                            height: 200,
                                            width: 200 * (2 / 3),
                                            color: Colors.white30,
                                          )))))),
                    ],
                  ))
            ]));
  }

  void checkIfCategoryInitialized() {
    // If category is not present then we load datas from API endpoint
    if (!homeCategoryprovider.isCategoryPresent(categoryTitle)) {
      // get datas
      itemsFuture = UserService.getLatestMedia(
          fields: 'DateCreated, DateAdded, ImageTags');

      // Add category to BLoC
      itemsFuture.then((value) =>
          homeCategoryprovider.addCategory(MapEntry(categoryTitle, value)));
    } else {
      itemsFuture =
          Future.value(homeCategoryprovider.getCategoryItem(categoryTitle));
    }
  }

  dynamic fallbackBlurHash(Map<String, dynamic> bhPrimary, String? key) {
    key ??= bhPrimary.keys.first;
    return bhPrimary[key];
  }
}
