import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/components/collection.dart';
import 'package:jellyflut/screens/details/template/components/action_button/details_button_row_buider.dart';
import 'package:jellyflut/screens/details/template/components/details/quick_infos.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab_header.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:rxdart/rxdart.dart';

class RightDetails extends StatefulWidget {
  final Item item;
  final Widget? posterAndLogoWidget;
  RightDetails({Key? key, required this.item, this.posterAndLogoWidget})
      : super(key: key);

  @override
  _RightDetailsState createState() => _RightDetailsState();
}

class _RightDetailsState extends State<RightDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late ThemeData _theme;
  late Item item;
  late final DetailsBloc _detailsBloc;
  late final BehaviorSubject<int> _indexStream;
  late final ScrollController _scrollController;
  late final Future<Category> seasons;

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
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
      stream: _detailsBloc.themeStream,
      builder: (context, snapshot) {
        return Theme(data: snapshot.data ?? _theme, child: body(item));
      },
    );
  }

  Widget body(final Item item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 48)),
          SliverToBoxAdapter(
              child: widget.posterAndLogoWidget ?? const SizedBox()),
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
          SliverToBoxAdapter(child: QuickInfos(item: item)),
          SliverToBoxAdapter(child: const SizedBox(height: 12)),
          SliverToBoxAdapter(
              child: OverviewDetailsWidget(overview: item.overview)),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: ProvidersDetailsWidget(item: item)),
          SliverToBoxAdapter(child: const SizedBox(height: 12)),
          SliverToBoxAdapter(child: PeoplesDetailsWidget(item: item)),
          // Shown only if current item is a series (because it contains seasons)
          if (item.type == ItemType.SERIES)
            SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate:
                    TabHeader(seasons: seasons, tabController: _tabController)),
          SliverToBoxAdapter(
            child: FutureBuilder<Category>(
                future: seasons,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Collection(item,
                        indexStream: _indexStream,
                        seasons: snapshot.data?.items ?? <Item>[]);
                  }
                  return const SizedBox();
                }),
          )
        ],
      ),
    );
  }
}
