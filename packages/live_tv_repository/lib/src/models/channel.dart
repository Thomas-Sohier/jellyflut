import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:collection/collection.dart' as c;

import 'program.dart';
import 'parse_channel_from_jellyfin.dart';

class Channel {
  final Item channel;
  final List<Program> programs;

  const Channel({required this.channel, this.programs = const <Program>[]});

  /// Parse channels from [ParseChannelFromJellyfin], take only one param (useful
  /// for compute method)
  static List<Channel> parseChannels(ParseChannelFromJellyfin params) {
    final channels = <Channel>[];
    c.groupBy(params.programs, (Item v) => v.channelId).map((key, value) {
      final item = params.channels.firstWhere((c) => c.id == key);
      return MapEntry(item, value);
    }).forEach((key, value) {
      final programs = value.map((v) => Program.fromItem(v)).toList();
      channels.add(Channel(channel: key, programs: programs));
    });
    return channels;
  }
}
