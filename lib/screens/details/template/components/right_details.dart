import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/details/template/components/action_button/details_button_row_buider.dart';
import 'package:jellyflut/screens/details/template/components/details/quick_infos.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab_header.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'items_collection/cubit/collection_cubit.dart';
import 'items_collection/season_episode.dart';

class RightDetails extends StatefulWidget {
  final Item item;
  final Widget? posterAndLogoWidget;
  RightDetails({super.key, required this.item, this.posterAndLogoWidget});

  @override
  State<RightDetails> createState() => _RightDetailsState();
}

class _RightDetailsState extends State<RightDetails> with TickerProviderStateMixin {
  bool isHeaderPinned = false;

  Item get item => widget.item;
  Widget? get posterAndLogoWidget => widget.posterAndLogoWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionCubit(
          itemsRepository: context.read<ItemsRepository>(),
          item: item,
          tabController: TabController(length: 0, vsync: this)),
      child: BlocListener<CollectionCubit, CollectionState>(
          listener: (context, state) {
            context.read<CollectionCubit>().tabController = TabController(length: state.episodes.length, vsync: this);
          },
          child: RightDetailsView(item: item, posterAndLogoWidget: posterAndLogoWidget)),
    );
  }
}

class RightDetailsView extends StatelessWidget {
  final Item item;
  final Widget? posterAndLogoWidget;
  static const contentPadding = EdgeInsets.symmetric(horizontal: 12);
  static const horizotalScrollbaleWidgetPadding = EdgeInsets.only(left: 12);

  const RightDetailsView({super.key, required this.item, this.posterAndLogoWidget});

  @override
  Widget build(BuildContext context) {
    SliverPadding boxAdapter(Widget? child) {
      return SliverPadding(padding: contentPadding, sliver: SliverToBoxAdapter(child: child ?? const SizedBox()));
    }

    return CustomScrollView(scrollDirection: Axis.vertical, slivers: [
      boxAdapter(const SizedBox(height: 48)),
      boxAdapter(posterAndLogoWidget),
      boxAdapter(const SizedBox(height: 24)),
      boxAdapter(Align(alignment: Alignment.centerLeft, child: DetailsButtonRowBuilder(item: item))),
      boxAdapter(const SizedBox(height: 36)),
      boxAdapter(TaglineDetailsWidget(item: item)),
      boxAdapter(const SizedBox(height: 24)),
      boxAdapter(Row(children: [
        TitleDetailsWidget(title: item.name),
        const SizedBox(width: 8),
        RatingDetailsWidget(rating: item.officialRating),
      ])),
      if (item.haveDifferentOriginalTitle()) boxAdapter(OriginalTitleDetailsWidget(title: item.originalTitle)),
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
          delegate: TabHeader(padding: horizotalScrollbaleWidgetPadding),
        ),
      if (item.type == ItemType.SERIES) boxAdapter(SeasonEpisode()),
      boxAdapter(const SizedBox(height: 24)),
    ]);
  }
}
