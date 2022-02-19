import 'dart:collection';

import 'package:collection/collection.dart' as c;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class Channels extends StatefulWidget {
  final List<Item> channels;
  final List<Item> programs;
  Channels({Key? key, required this.channels, required this.programs})
      : super(key: key);

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  late final SplayTreeMap<Item, List<Item>> channels;
  late final ScrollController _controller;
  final DateFormat formatter = DateFormat('HH:mm');

  @override
  void initState() {
    _controller = ScrollController();
    channels = SplayTreeMap.from(
        c.groupBy(widget.programs, (Item v) => v.channelId).map((key, value) {
          final item = widget.channels.firstWhere((c) => c.id == key);
          return MapEntry(item, value);
        }),
        (item1, item2) => int.parse(item1.channelNumber!)
            .compareTo(int.parse(item2.channelNumber!)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: channels.length,
        padding: EdgeInsets.zero,
        itemBuilder: ((context, index) {
          final channel = channels.keys.elementAt(index);
          final programs = channels.values.elementAt(index);
          return SizedBox(
            height: 70,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    OutlinedButtonSelector(
                      onPressed: () => customRouter.push(
                          DetailsRoute(item: channel, heroTag: channel.id)),
                      child: SizedBox(
                        width: 80,
                        child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, right: 4),
                                child: Poster(
                                    tag: ImageType.PRIMARY,
                                    heroTag: channel.id,
                                    clickable: false,
                                    boxFit: BoxFit.contain,
                                    item: channel),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Card(
                                      elevation: 2,
                                      margin: EdgeInsets.zero,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 2, 4, 2),
                                        child: Text(
                                          channel.channelNumber ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary)
                                              .copyWith(fontSize: 12),
                                        ),
                                      ))),
                            ]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: programList(programs)),
                  ],
                )),
          );
        }));
  }

  Widget programList(List<Item> channel) {
    return ListView.builder(
        itemCount: channel.length,
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final program = channel.elementAt(index);
          return programBuilder(program);
        });
  }

  Widget programBuilder(Item program) {
    final width =
        (program.endDate!.difference(program.startDate!).inMinutes * 10)
            .toDouble();
    return OutlinedButtonSelector(
      onPressed: () =>
          customRouter.push(DetailsRoute(item: program, heroTag: program.id)),
      child: Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 4),
          color: ColorUtil.darken(Theme.of(context).cardTheme.color!),
          child: SizedBox(
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        program.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      formatter.format(program.startDate!) +
                          ' - ' +
                          formatter.format(program.endDate!),
                      style: Theme.of(context).textTheme.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
              ))),
    );
  }
}
