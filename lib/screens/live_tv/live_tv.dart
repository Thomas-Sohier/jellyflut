import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut/screens/home/home_tabs_cubit/home_tabs_cubit.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:live_tv_repository/live_tv_repository.dart';

import 'bloc/live_tv_guide_cubit.dart';
import 'guide_view.dart';

const Key _tabControllerKey = ValueKey('LiveTvKey');

class LiveTvPage extends StatefulWidget {
  // This property is there to generate key property with build_runner and allow to use it in [HomeTab] mixin
  // ignore: unused_field
  final String? _blank;

  const LiveTvPage({super.key, String? blank}) : _blank = blank;

  @override
  State<LiveTvPage> createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> with TickerProviderStateMixin, HomeTab {
  @override
  List<Widget> get tabs => const <Tab>[Tab(text: 'Chaines'), Tab(text: 'Guide')];

  @override
  TabController get tabController => TabController(length: tabs.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LiveTvGuideCubit(liveTvRepository: context.read<LiveTvRepository>()),
      child: super.visibiltyBuilder(child: const LiveTvView()),
    );
  }

  @override
  Key get tabControllerUniqueKey => _tabControllerKey;
}

class LiveTvView extends StatelessWidget {
  const LiveTvView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabControllers =
        context.select<HomeTabsCubit, Map<Key, HomeTabController>>((cubit) => cubit.state.homeTabControllers);
    return BlocBuilder<LiveTvGuideCubit, LiveTvGuideState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        switch (state.status) {
          case LiveTvGuideStatus.initial:
          case LiveTvGuideStatus.loading:
          case LiveTvGuideStatus.success:
            return TabBarView(
              controller: tabControllers[_tabControllerKey]?.tabController,
              children: const [ChannelsView(), GuideView()],
            );
          case LiveTvGuideStatus.failure:
            return const _ChannelFailure();
          default:
            return const SizedBox();
        }
      },
    );
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
      notFoundPlaceholder: const _ChannelPlaceholder(),
      verticalListPosterHeight: 150,
      gridPosterHeight: 120,
      boxFit: BoxFit.contain,
      listType: ListType.grid,
    );
  }
}

class _ChannelPlaceholder extends StatelessWidget {
  const _ChannelPlaceholder();

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

class _ChannelFailure extends StatelessWidget {
  const _ChannelFailure();

  @override
  Widget build(BuildContext context) {
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
  }
}
