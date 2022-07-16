import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:live_tv_repository/live_tv_repository.dart';

import 'bloc/live_tv_guide_cubit.dart';

class LiveTvPage extends StatelessWidget {
  const LiveTvPage({super.key});

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
        child: TabBarView(
      controller: super.tabController,
      children: const [ChannelsView(), GuideView()],
    ));
  }
}

class ChannelsView extends StatelessWidget {
  const ChannelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListItems.fromCustomRequest(
      fetchMethod: (startIndex, limit) {
        context.read<LiveTvGuideCubit>().loadLiveTvGuide();
        return context.read<LiveTvRepository>().getChannels(startIndex: startIndex, limit: limit);
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

class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
