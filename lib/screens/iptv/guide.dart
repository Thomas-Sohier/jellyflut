import 'package:flutter/material.dart';
import 'package:jellyflut/models/iptv/programs_request_body.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/livetv/livetv_service.dart';
import 'package:collection/collection.dart' as c;
import 'package:jellyflut/shared/utils/color_util.dart';

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
            final programs =
                c.groupBy(snapshot.data!.items, (Item v) => v.channelId);
            return ListView.builder(
                itemCount: programs.length,
                itemBuilder: ((context, index) => Card(
                      color:w
                          ColorUtil.darken(Theme.of(context).cardTheme.color!),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                widget.items
                                    .firstWhere((element) =>
                                        element.id ==
                                        programs.keys.elementAt(index))
                                    .name,
                                style: Theme.of(context).textTheme.headline6),
                            const SizedBox(height: 12),
                            Text(programs.values
                                .elementAt(index)
                                .map((e) => e.name)
                                .join(', ')),
                          ],
                        ),
                      ),
                    )));
          }
          return const SizedBox();
        });
  }
}
