import 'package:flutter/material.dart';
import 'package:jellyflut/components/home_tab.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/iptv/channels_request_body.dart';
import 'package:jellyflut/models/iptv/programs_request_body.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/screens/iptv/guide.dart';
import 'package:jellyflut/services/livetv/livetv_service.dart';

class Iptv extends StatefulWidget {
  Iptv({Key? key}) : super(key: key);

  @override
  _IptvState createState() => _IptvState();
}

class _IptvState extends State<Iptv> with HomeTab {
  late final Future<Category> programs;

  @override
  void initState() {
    super.initState();
    programs = IptvService.getChannels();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(excluding: excluding, child: tabs());
  }

  Widget tabs() {
    return DefaultTabController(
        length: 2,
        child: Column(children: [
          const TabBar(tabs: [Tab(text: 'Chaines'), Tab(text: 'Guide')]),
          Expanded(
            child: TabBarView(
              children: [listItems(), guide()],
            ),
          )
        ]));
  }

  Widget listItems() {
    return ListItems.fromFuture(
      itemsFuture: programs,
      verticalListPosterHeight: 250,
      gridPosterHeight: 100,
      listType: ListType.GRID,
      loadMoreFunction: (int startIndex, int numberOfItemsToLoad) {
        return IptvService.getChannels(
            body: ChannelsRequestBody(
                startIndex: startIndex, limit: numberOfItemsToLoad));
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
