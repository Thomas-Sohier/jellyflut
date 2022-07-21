import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/album/album.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'action_button/details_button_row_buider.dart';
import 'details/header.dart';
import 'details/quick_infos.dart';
import 'details_widgets.dart';
import 'items_collection/seasons/seasons.dart';

class RightDetails extends StatelessWidget {
  static const contentPadding = EdgeInsets.symmetric(horizontal: 12);
  static const horizotalScrollbaleWidgetPadding = EdgeInsets.only(left: 12);

  const RightDetails({super.key});

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
      const SliverPadding(padding: contentPadding, sliver: DetailsButtonRowBuilder()),
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
      const PeoplesDetailsWidget(
          padding: horizotalScrollbaleWidgetPadding), // Shown only if current item is a not a person
      const Seasons(), // Shown only if current item is a series (because it contains seasons)
      const Album(), // Shown only if current item is an album (because it contains songs and discs)
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
