import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:live_tv_repository/live_tv_repository.dart';

import 'bloc/live_tv_guide_cubit.dart';
import 'guide_view.dart';

class LiveTvPage extends StatelessWidget {
  /// This property is only there to make auto_route generate page arguments so
  /// we can pass a key to the route. Auto_route doesn't generate page arguments
  /// if there is only [super.key] as a param
  ///
  /// Do nothing
  final String? blank;
  const LiveTvPage({super.key, this.blank});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LiveTvGuideCubit(liveTvRepository: context.read<LiveTvRepository>()),
      child: const LiveTvView(),
    );
  }
}

class LiveTvView extends StatefulWidget {
  const LiveTvView({super.key});

  @override
  State<LiveTvView> createState() => _LiveTvViewState();
}

class _LiveTvViewState extends State<LiveTvView> with HomeTab, TickerProviderStateMixin {
  @override
  List<Widget> get tabs => [Tab(text: 'Chaines'), Tab(text: 'Guide')];

  @override
  set tabController(TabController tabController) {
    super.tabController = tabController;
  }

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return super.parentBuild(
        child: BlocBuilder<LiveTvGuideCubit, LiveTvGuideState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        switch (state.status) {
          case LiveTvGuideStatus.initial:
          case LiveTvGuideStatus.loading:
          case LiveTvGuideStatus.success:
            return TabBarView(
              controller: super.tabController,
              children: const [ChannelsView(), GuideView()],
            );
          case LiveTvGuideStatus.failure:
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load TV channels'),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () => context.read<LiveTvGuideCubit>().loadLiveTvGuide(),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox();
        }
      },
    ));
  }
}

class ChannelsView extends StatelessWidget {
  const ChannelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListItems.fromCustomRequest(
      fetchMethod: (startIndex, limit) async {
        await context.read<LiveTvGuideCubit>().loadLiveTvGuide(startIndex: startIndex, limit: limit);
        return context.read<LiveTvGuideCubit>().state.guide.map((e) => e.channel).toList();
      },
      notFoundPlaceholder: const ChannelPlaceholder(),
      verticalListPosterHeight: 150,
      gridPosterHeight: 100,
      boxFit: BoxFit.contain,
      listType: ListType.grid,
    );
  }
}

class ChannelPlaceholder extends StatelessWidget {
  const ChannelPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtil.darken(Theme.of(context).colorScheme.background),
      child: Center(
        child: Icon(Icons.tv, color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
