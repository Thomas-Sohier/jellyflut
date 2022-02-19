import 'package:flutter/material.dart';
import 'package:jellyflut/models/iptv/programs_request_body.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/iptv/program.dart';
import 'package:jellyflut/services/livetv/livetv_service.dart';

class Guide extends StatefulWidget {
  final List<Item> items;
  Guide({Key? key, required this.items}) : super(key: key);

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  late final List<String> channelsIds;
  late final Future<Category> programsFuture;

  @override
  void initState() {
    super.initState();
    channelsIds = widget.items.map((e) => e.id).toList();
    programsFuture = IptvService.getPrograms(
        body: ProgramsRequestBody(channelIds: channelsIds));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: programsFuture,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return Channels(
                channels: widget.items, programs: snapshot.data!.items);
          }
          return const SizedBox();
        });
  }
}
