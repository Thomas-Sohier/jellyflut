import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/home/home_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/home/home_category_title.dart';
import 'package:jellyflut/theme.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategory extends StatefulWidget {
  final Item item;
  const HomeCategory(this.item);

  @override
  State<StatefulWidget> createState() {
    return _HomeCategoryState();
  }
}

class _HomeCategoryState extends State<HomeCategory> with AutomaticKeepAliveClientMixin {
  final double height = 220;
  final double gapSize = 20;
  late final String categoryTitle;
  late final HomeCategoryProvider homeCategoryprovider;
  late final Future<List<Item>> itemsFuture;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    categoryTitle = widget.item.name ?? '';
    scrollController = ScrollController(initialScrollOffset: 0);
    homeCategoryprovider = HomeCategoryProvider();
    checkIfCategoryInitialized();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void slideToPageDetail() {
    customRouter.push(CollectionParentRoute(
      item: widget.item,
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<List<Item>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          if (snapshot.data!.isEmpty) {
            return const SizedBox();
          }
          return buildCategory();
        } else {
          return placeholder();
        }
      },
    );
  }

  Widget buildCategory() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeCategoryTitle(categoryTitle, onTap: slideToPageDetail),
          SizedBox(height: itemPosterHeight + itemPosterLabelHeight, child: displayItems()),
        ]);
  }

  Widget displayItems() {
    final items = homeCategoryprovider.getCategoryItem(categoryTitle);
    final itemAspectRatio = items.first.getPrimaryAspectRatio(showParent: true);

    // Plus 10 to add some spacing between items, plus add performance
    final itemWidth = (itemPosterHeight * itemAspectRatio) + 20;
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemExtent: itemWidth,
        controller: scrollController,
        itemBuilder: (context, index) => ItemPoster(
              items[index],
              width: double.infinity,
              height: double.infinity,
              boxFit: BoxFit.cover,
            ));
  }

  Widget placeholder() {
    return Shimmer.fromColors(
        enabled: shimmerAnimation,
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                    height: 30,
                    width: 70,
                    color: Colors.white30,
                  )),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.white30,
                      ))),
            ],
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                          height: itemPosterHeight,
                          child: ListView.builder(
                              itemCount: 3,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height: height,
                                        width: height * (2 / 3),
                                        color: Colors.white30,
                                      )))))),
                ],
              ))
        ]));
  }

  /// Check if items are already initn and if not then we do load datas from API
  void checkIfCategoryInitialized() {
    // If category is not present then we load datas from API endpoint
    if (!homeCategoryprovider.isCategoryPresent(categoryTitle)) {
      // get datas
      itemsFuture = context
          .read<ItemsRepository>()
          .getLatestMedia(parentId: widget.item.id, fields: 'DateCreated, DateAdded, ImageTags');

      // Add category to BLoC
      itemsFuture.then((value) => homeCategoryprovider.addCategory(MapEntry(categoryTitle, value)));
    } else {
      itemsFuture = Future.value(homeCategoryprovider.getCategoryItem(categoryTitle));
    }
  }

  dynamic fallbackBlurHash(Map<String, dynamic> bhPrimary, String? key) {
    key ??= bhPrimary.keys.first;
    return bhPrimary[key];
  }
}
