import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/action_button/details_button_row_buider.dart';
import 'package:jellyflut/screens/details/template/components/collection.dart';
import 'package:jellyflut/screens/details/template/components/details/quick_infos.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab_header.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:rxdart/rxdart.dart';

class RightDetails extends StatefulWidget {
  final Item item;
  final Widget? posterAndLogoWidget;
  RightDetails({super.key, required this.item, this.posterAndLogoWidget});

  @override
  State<RightDetails> createState() => _RightDetailsState();
}

class _RightDetailsState extends State<RightDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool isHeaderPinned = false;
  late ThemeData _theme;
  late Item item;
  late final DetailsBloc _detailsBloc;
  late final BehaviorSubject<int> _indexStream;
  late final ScrollController _scrollController;
  late final Future<Category> seasons;
  static const contentPadding = EdgeInsets.symmetric(horizontal: 12);
  static const horizotalScrollbaleWidgetPadding = EdgeInsets.only(left: 12);

  @override
  void initState() {
    super.initState();
    item = widget.item;
    _detailsBloc = BlocProvider.of<DetailsBloc>(context);
    _scrollController = ScrollController();
    _indexStream = BehaviorSubject.seeded(0);
    seasons = ItemService.getItems(
        parentId: item.id,
        limit: 100,
        fields: 'ImageTags, RecursiveItemCount',
        filter: 'IsFolder');
    _tabController = TabController(length: item.childCount ?? 0, vsync: this);
    _tabController!.addListener(() {
      _indexStream.add(_tabController!.index);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  void didUpdateWidget(RightDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    item = widget.item;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
      stream: _detailsBloc.themeStream,
      builder: (context, snapshot) {
        return Theme(data: snapshot.data ?? _theme, child: body(item));
      },
    );
  }

  Widget body(final Item item) {
    SliverPadding boxAdapter(Widget? child) {
      return SliverPadding(
          padding: contentPadding,
          sliver: SliverToBoxAdapter(child: child ?? const SizedBox()));
    }

    return CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        slivers: [
          boxAdapter(const SizedBox(height: 48)),
          boxAdapter(widget.posterAndLogoWidget),
          boxAdapter(const SizedBox(height: 24)),
          boxAdapter(Align(
              alignment: Alignment.centerLeft,
              child: DetailsButtonRowBuilder(item: item))),
          boxAdapter(const SizedBox(height: 36)),
          boxAdapter(TaglineDetailsWidget(item: item)),
          boxAdapter(const SizedBox(height: 24)),
          boxAdapter(Row(children: [
            TitleDetailsWidget(title: item.name),
            const SizedBox(width: 8),
            RatingDetailsWidget(rating: item.officialRating),
          ])),
          if (item.haveDifferentOriginalTitle())
            boxAdapter(OriginalTitleDetailsWidget(title: item.originalTitle)),
          boxAdapter(const SizedBox(height: 8)),
          boxAdapter(QuickInfos(item: item)),
          boxAdapter(const SizedBox(height: 12)),
          boxAdapter(OverviewDetailsWidget(overview: item.overview)),
          boxAdapter(const SizedBox(height: 24)),
          boxAdapter(ProvidersDetailsWidget(item: item)),
          boxAdapter(const SizedBox(height: 12)),
          SliverToBoxAdapter(
              child: PeoplesDetailsWidget(
            item: item,
            padding: horizotalScrollbaleWidgetPadding,
          )),
          // Shown only if current item is a series (because it contains seasons)
          if (item.type == ItemType.SERIES)
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: TabHeader(
                  seasons: seasons,
                  tabController: _tabController,
                  padding: horizotalScrollbaleWidgetPadding),
            ),
          boxAdapter(SeasonEpisode()),
          boxAdapter(const SizedBox(height: 24)),
        ]);
  }

  Widget SeasonEpisode() {
    return FutureBuilder<Category>(
        future: seasons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Collection(item,
                indexStream: _indexStream,
                seasons: snapshot.data?.items ?? <Item>[]);
          }
          return const SizedBox();
        });
  }
}
