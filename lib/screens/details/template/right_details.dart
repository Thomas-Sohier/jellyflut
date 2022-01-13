import 'package:flutter/material.dart';

import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/components/collection.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/screens/details/template/components/action_button/details_button_row_buider.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';
import 'package:jellyflut/services/item/item_service.dart';

class RightDetails extends StatefulWidget {
  final Item item;
  RightDetails({Key? key, required this.item}) : super(key: key);

  @override
  _RightDetailsState createState() => _RightDetailsState();
}

class _RightDetailsState extends State<RightDetails>
    with SingleTickerProviderStateMixin {
  late final Item item;
  late final ScrollController _scrollController;
  late final Future<Category> seasons;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    _scrollController = ScrollController();
    seasons = ItemService.getItems(
        parentId: item.id,
        limit: 100,
        fields: 'ImageTags, RecursiveItemCount',
        filter: 'IsFolder');
    seasons.then((value) {
      _tabController = TabController(length: value.items.length, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: NestedScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (context, value) {
          return [
            if (item.hasLogo()) SliverToBoxAdapter(child: Logo(item: item)),
            SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: DetailsButtonRowBuilder(item: item))),
            SliverToBoxAdapter(child: SizedBox(height: 36)),
            SliverToBoxAdapter(child: TaglineDetailsWidget(item: item)),
            SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
                child: Row(children: [
              TitleDetailsWidget(title: item.name),
              SizedBox(width: 8),
              RatingDetailsWidget(rating: item.officialRating),
            ])),
            if (item.originalTitle != null &&
                item.originalTitle!.toLowerCase() != item.name.toLowerCase())
              SliverToBoxAdapter(
                  child: OriginalTitleDetailsWidget(title: item.originalTitle)),
            SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(
                child: Row(
              children: [
                Expanded(
                  child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (item.hasRatings())
                          Critics(
                              item: item,
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.fontSize ??
                                  16),
                        // Spacer(),
                        InfosDetailsWidget(item: item),
                      ]),
                ),
              ],
            )),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(
                child: OverviewDetailsWidget(overview: item.overview)),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
            SliverToBoxAdapter(child: ProvidersDetailsWidget(item: item)),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(child: PeoplesDetailsWidget(item: item)),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: FutureBuilder<Category>(
                  future: seasons,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children:
                              getTabsHeader(snapshot.data?.items ?? <Item>[]),
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
            )
          ];
        },
        body: FutureBuilder<Category>(
            future: seasons,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Collection(item,
                    tabController: _tabController,
                    seasons: snapshot.data?.items ?? <Item>[]);
              }
              return const SizedBox();
            }),
      ),
    );
  }

  List<Widget> getTabsHeader(List<Item> items) {
    final headers = <Widget>[];
    final length = items.length;
    items.sort((Item item1, Item item2) =>
        item1.indexNumber?.compareTo(item2.indexNumber ?? length + 1) ??
        length + 1);
    items.forEach(
        (Item item) => headers.add(tabHeader(item, items.indexOf(item))));
    return headers;
  }

  Widget tabHeader(Item item, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: PaletteButton(
        item.name,
        onPressed: () => _tabController.animateTo(index),
        borderRadius: 4,
        minWidth: 40,
        maxWidth: 150,
      ),
    );
  }
}
