import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/details/template/components/action_button/details_button_row_buider.dart';
import 'package:jellyflut/screens/details/template/components/collection.dart';
import 'package:jellyflut/screens/details/template/components/details/quick_infos.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab_header.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shimmer/shimmer.dart';

import 'items_collection/cubit/collection_cubit.dart';

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

class SeasonEpisode extends StatelessWidget {
  const SeasonEpisode({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionCubit = context.read<CollectionCubit>();
    return BlocConsumer<CollectionCubit, CollectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.status) {
          case CollectionStatus.failure:
            return const SeasonEpisodeError();
          case CollectionStatus.loading:
            return const EpisodesShimmer();
          case CollectionStatus.initial:
          case CollectionStatus.success:
            if (collectionCubit.seasons.isNotEmpty) {
              return Collection(collectionCubit.item, seasons: collectionCubit.seasons);
            }
            return const SizedBox();
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class SeasonEpisodeError extends StatelessWidget {
  const SeasonEpisodeError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Icon(Icons.error_outline),
          const SizedBox(height: 4),
          Text('error_loading_item'.tr(args: ['episodes'])),
        ],
      ),
    ));
  }
}

class EpisodesShimmer extends StatelessWidget {
  static const double padding = 12;
  static const double height = 150;
  final int count;
  const EpisodesShimmer({this.count = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (height + padding) * count,
        child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.background.withAlpha(150),
            highlightColor: Theme.of(context).colorScheme.background.withAlpha(100),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemExtent: height + padding,
                  itemCount: count,
                  itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(top: padding),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: Container(
                              height: height,
                              width: double.infinity,
                              color: Theme.of(context).colorScheme.background.withAlpha(150),
                            )),
                      )),
            )));
  }
}
