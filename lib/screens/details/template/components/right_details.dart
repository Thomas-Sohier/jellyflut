import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/action_button/details_button_row_buider.dart';
import 'package:jellyflut/screens/details/template/components/details/quick_infos.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab_header.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'details/header.dart';
import 'items_collection/cubit/collection_cubit.dart';
import 'items_collection/season_episode.dart';

class RightDetails extends StatefulWidget {
  const RightDetails({super.key});

  @override
  State<RightDetails> createState() => _RightDetailsState();
}

class _RightDetailsState extends State<RightDetails> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionCubit(
          itemsRepository: context.read<ItemsRepository>(),
          item: context.read<DetailsBloc>().state.item,
          tabController: TabController(length: 0, vsync: this)),
      child: BlocListener<CollectionCubit, CollectionState>(
          listener: (context, state) {
            context.read<CollectionCubit>().tabController = TabController(length: state.episodes.length, vsync: this);
          },
          child: const RightDetailsView()),
    );
  }
}

class RightDetailsView extends StatelessWidget {
  static const contentPadding = EdgeInsets.symmetric(horizontal: 12);
  static const horizotalScrollbaleWidgetPadding = EdgeInsets.only(left: 12);

  const RightDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      buildWhen: (previous, current) => previous.item != current.item,
      builder: (context, state) => scrollView(state.item),
    );
  }

  Widget scrollView(final Item item) {
    return CustomScrollView(scrollDirection: Axis.vertical, slivers: [
      const _BoxAdaptater(SizedBox(height: 48)),
      const _BoxAdaptater(Header()),
      const _BoxAdaptater(SizedBox(height: 24)),
      const _BoxAdaptater(Align(alignment: Alignment.centerLeft, child: DetailsButtonRowBuilder())),
      const _BoxAdaptater(SizedBox(height: 36)),
      const _BoxAdaptater(TaglineDetailsWidget()),
      const _BoxAdaptater(SizedBox(height: 24)),
      _BoxAdaptater(Row(children: const [
        TitleDetailsWidget(),
        SizedBox(width: 8),
        RatingDetailsWidget(),
      ])),
      const _BoxAdaptater(OriginalTitleDetailsWidget()),
      const _BoxAdaptater(SizedBox(height: 8)),
      const _BoxAdaptater(QuickInfos()),
      const _BoxAdaptater(SizedBox(height: 12)),
      const _BoxAdaptater(OverviewDetailsWidget()),
      const _BoxAdaptater(SizedBox(height: 24)),
      const _BoxAdaptater(ProvidersDetailsWidget()),
      const _BoxAdaptater(SizedBox(height: 12)),
      const _BoxAdaptater(PeoplesDetailsWidget(padding: horizotalScrollbaleWidgetPadding)),
      // Shown only if current item is a series (because it contains seasons)
      if (item.type == ItemType.Series)
        const SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: TabHeader(padding: horizotalScrollbaleWidgetPadding),
        ),
      if (item.type == ItemType.Series) const SeasonEpisode(),
      const _BoxAdaptater(SizedBox(height: 24)),
    ]);
  }
}

class _BoxAdaptater extends StatelessWidget {
  final Widget? child;
  final EdgeInsets padding;

  const _BoxAdaptater(this.child, {super.key, this.padding = const EdgeInsets.symmetric(horizontal: 12)});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(padding: padding, sliver: SliverToBoxAdapter(child: child ?? const SizedBox()));
  }
}
