import 'dart:collection';
import 'package:collection/collection.dart' as c;
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/skeleton/list_items_skeleton.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/iptv/programs_request_body.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/iptv/channels.dart';
import 'package:jellyflut/services/livetv/livetv_service.dart';
import 'package:jellyflut/theme.dart';
import 'package:shimmer/shimmer.dart';

class Guide extends StatefulWidget {
  final List<Item> items;
  Guide({Key? key, required this.items}) : super(key: key);

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> with AutomaticKeepAliveClientMixin {
  late final List<String> channelsIds;
  late final Future<Category> programsFuture;
  late final Future<SplayTreeMap<Item, List<Item>>> parsedPrograms;

  @override
  void initState() {
    super.initState();
    channelsIds = widget.items.map((e) => e.id).toList();
    programsFuture = IptvService.getPrograms(
        body: ProgramsRequestBody(channelIds: channelsIds));
    parsedPrograms = _initData();
  }

  Future<SplayTreeMap<Item, List<Item>>> _initData() async {
    final programs = await programsFuture;
    return compute(
        parseChannels,
        ParseChannelsParameters(
            channels: widget.items, programs: programs.items));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SplayTreeMap<Item, List<Item>>>(
        future: parsedPrograms,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return Channels(channels: snapshot.data!);
          }
          return placeholder();
        });
  }

  Widget placeholder() {
    return Shimmer.fromColors(
        enabled: shimmerAnimation,
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: ListView.builder(
            itemCount: 12,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: ((context, index) => Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SkeletonItemPoster(aspectRatio: 16 / 9),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(color: Colors.white30),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  @override
  bool get wantKeepAlive => true;
}

SplayTreeMap<Item, List<Item>> parseChannels(ParseChannelsParameters params) {
  return SplayTreeMap.from(
      c.groupBy(params.programs, (Item v) => v.channelId).map((key, value) {
        final item = params.channels.firstWhere((c) => c.id == key);
        return MapEntry(item, value);
      }),
      (item1, item2) => int.parse(item1.channelNumber!)
          .compareTo(int.parse(item2.channelNumber!)));
}

class ParseChannelsParameters {
  final List<Item> channels;
  final List<Item> programs;

  ParseChannelsParameters({required this.channels, required this.programs});
}
