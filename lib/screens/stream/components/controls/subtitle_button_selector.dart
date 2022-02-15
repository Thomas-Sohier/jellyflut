import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';
import 'package:jellyflut/screens/stream/model/media_type.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class SubtitleButtonSelector extends StatefulWidget {
  SubtitleButtonSelector({Key? key}) : super(key: key);

  @override
  _SubtitleButtonSelectorState createState() => _SubtitleButtonSelectorState();
}

class _SubtitleButtonSelectorState extends State<SubtitleButtonSelector> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;
  late final GlobalKey<PopupMenuButtonState<Subtitle>> _popupMenuButtonKey;
  late int subtitleSelectedIndex;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        skipTraversal: true);
    streamingProvider = StreamingProvider();
    subtitleSelectedIndex =
        streamingProvider.selectedSubtitleTrack?.index ?? -1;
    _popupMenuButtonKey = GlobalKey();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => _popupMenuButtonKey.currentState?.showButtonMenu(),
        shape: CircleBorder(),
        child: changeSubtitle(context));
  }

  Widget changeSubtitle(BuildContext context) {
    return IgnorePointer(
        child: FutureBuilder<List<Subtitle>>(
      future: streamingProvider.getSubtitles(),
      builder: (context, snapshot) => PopupMenuButton<Subtitle>(
          key: _popupMenuButtonKey,
          icon: Icon(
            Icons.subtitles,
            color: Colors.white,
          ),
          tooltip: 'select_subtitle'.tr(),
          onSelected: (Subtitle subtitle) => setSubtitle(subtitle),
          itemBuilder: (context) {
            if (snapshot.hasData) {
              return _audioTracksListTile(snapshot.data!);
            }
            return <PopupMenuEntry<Subtitle>>[];
          }),
    ));
  }

  List<PopupMenuEntry<Subtitle>> _audioTracksListTile(
      List<Subtitle> subtitlesTracks) {
    final list = <PopupMenuEntry<Subtitle>>[];

    // TITLE
    list.add(PopupMenuItem(child: Text('select_subtitle'.tr())));

    if (subtitlesTracks.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('no_subtitles'.tr())));
      return list;
    }

    // If subtitles list is not empty the we show disabled button at start of list
    final disabledSubtitle =
        Subtitle(index: -1, name: 'disabled'.tr(), mediaType: MediaType.LOCAL);
    list.add(
      CheckedPopupMenuItem(
        value: disabledSubtitle,
        checked: isSelected(disabledSubtitle),
        child: Text(
          'disabled'.tr(),
        ),
      ),
    );

    // LOCAL SUBTITLES
    final localSubtitles = subtitlesTracks
        .where((element) => element.mediaType == MediaType.LOCAL)
        .toList();
    list.add(PopupMenuDivider(height: 10));
    list.add(listItemTitle(
        child: Text(
      'embeded_subtitles'.tr(),
      style: Theme.of(context).textTheme.bodyText2,
    )));

    if (localSubtitles.isEmpty) {
      list.add(PopupMenuItem(
          enabled: false,
          child: Align(
              alignment: Alignment.center, child: Text('no_subtitles'.tr()))));
    } else {
      for (var index = 0; index < localSubtitles.length; index++) {
        final subtitle = localSubtitles[index];
        list.add(
          CheckedPopupMenuItem(
            value: subtitle,
            checked: subtitle.index == subtitleSelectedIndex,
            child: Text(subtitle.name),
          ),
        );
      }
    }

    // REMOTE SUBTITLES
    list.add(PopupMenuDivider(height: 10));
    list.add(
      listItemTitle(
          child: Text(
        'remote_subtitles'.tr(),
        style: Theme.of(context).textTheme.bodyText2,
      )),
    );

    final remoteSubtitles = subtitlesTracks
        .where((element) => element.mediaType == MediaType.REMOTE)
        .toList();
    if (remoteSubtitles.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('no_subtitles'.tr())));
    } else {
      for (var index = 0; index < remoteSubtitles.length; index++) {
        final subtitle = remoteSubtitles[index];
        list.add(CheckedPopupMenuItem(
          value: subtitle,
          checked: subtitle.index == subtitleSelectedIndex,
          child: Text(subtitle.name),
        ));
      }
    }
    // REMOTE SUBTITLES
    return list;
  }

  PopupMenuEntry<Subtitle> listItemTitle({required Widget child}) {
    return PopupMenuItem(
        padding: EdgeInsets.symmetric(horizontal: 4),
        height: 30,
        enabled: false,
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: ColorUtil.darken(
                    Theme.of(context).colorScheme.background, 0.1)),
            child: child));
  }

  bool isSelected(Subtitle subtitle) {
    return subtitleSelectedIndex == subtitle.index;
  }

  void disableSubtitles(Subtitle subtitle) {
    subtitleSelectedIndex = subtitle.index;

    // We tell the player to hide subtitles only if it's local
    if (subtitle.mediaType == MediaType.LOCAL) {
      streamingProvider.commonStream!.disableSubtitles();
    }
  }

  void setSubtitle(Subtitle subtitle) async {
    subtitleSelectedIndex = subtitle.index;
    streamingProvider.setSubtitleStreamIndex(subtitle);

    // We tell the player to show subtitles only if it's local
    // Via remote we use our own code for compatitbility
    if (subtitle.mediaType == MediaType.LOCAL) {
      streamingProvider.commonStream!.setSubtitle(subtitle);
    }
  }
}
