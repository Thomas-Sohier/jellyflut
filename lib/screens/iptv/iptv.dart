import 'package:flutter/material.dart';
import 'package:jellyflut/components/home_tab.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
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
    programs = IptvService.getPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
        excluding: excluding,
        child: ListItems.fromFuture(
          itemsFuture: programs,
          verticalListPosterHeight: 250,
          listType: ListType.GRID,
          loadMoreFunction: (int startIndex, int numberOfItemsToLoad) {
            return IptvService.getPrograms(
                startIndex: startIndex, limit: numberOfItemsToLoad);
          },
        ));
  }
}
