import 'package:flutter/material.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/screens/iptv/guide.dart';
import 'package:jellyflut/services/livetv/livetv_service.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class Iptv extends StatefulWidget {
  Iptv({super.key});

  @override
  State<Iptv> createState() => _IptvState();
}

class _IptvState extends State<Iptv> with HomeTab, TickerProviderStateMixin {
  late final Future<Category> programs;

  @override
  List<Widget> get tabs => [Tab(text: 'Chaines'), Tab(text: 'Guide')];

  @override
  set tabController(TabController tabController) {
    super.tabController = tabController;
  }

  @override
  void initState() {
    programs = IptvService.getChannels();
    tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return super.parentBuild(
        child: TabBarView(
      controller: super.tabController,
      children: [listItems(), guide()],
    ));
  }

  Widget listItems() {
    return ListItems.fromFuture(
      itemsFuture: programs,
      notFoundPlaceholder: Container(
        color: ColorUtil.darken(Theme.of(context).colorScheme.background),
        child: Center(
          child: Icon(Icons.tv, color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      verticalListPosterHeight: 150,
      gridPosterHeight: 100,
      boxFit: BoxFit.contain,
      listType: ListType.GRID,
      loadMoreFunction: (int startIndex, int numberOfItemsToLoad) {
        return IptvService.getChannels(body: ChannelsRequestBody(startIndex: startIndex, limit: numberOfItemsToLoad));
      },
    );
  }

  Widget guide() {
    return FutureBuilder<Category>(
        future: programs,
        builder: (_, snap) {
          if (snap.hasData) {
            return Guide(items: snap.data!.items);
          }
          return const SizedBox();
        });
  }
}
