import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:streaming_repository/streaming_repository.dart';

import '../../cubit/stream_cubit.dart';

class SubtitleButtonSelector extends StatefulWidget {
  const SubtitleButtonSelector({super.key});

  @override
  State<SubtitleButtonSelector> createState() => _SubtitleButtonSelectorState();
}

class _SubtitleButtonSelectorState extends State<SubtitleButtonSelector> {
  late final GlobalKey<PopupMenuButtonState<Subtitle>> _popupMenuButtonKey;
  @override
  void initState() {
    super.initState();
    _popupMenuButtonKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => _popupMenuButtonKey.currentState?.showButtonMenu(),
        shape: CircleBorder(),
        child: changeSubtitle(context));
  }

  Widget changeSubtitle(BuildContext context) {
    return ExcludeFocus(
      child: IgnorePointer(
          child: FutureBuilder<List<Subtitle>>(
        future: context.read<StreamCubit>().getSubtitles(),
        builder: (context, snapshot) => PopupMenuButton<Subtitle>(
            key: _popupMenuButtonKey,
            icon: Icon(
              Icons.subtitles,
              color: Colors.white,
            ),
            tooltip: 'select_subtitle'.tr(),
            onSelected: context.read<StreamCubit>().setSubtitleStreamIndex,
            itemBuilder: (context) {
              if (snapshot.hasData) {
                return _audioTracksListTile(snapshot.data!);
              }
              return <PopupMenuEntry<Subtitle>>[];
            }),
      )),
    );
  }

  List<PopupMenuEntry<Subtitle>> _audioTracksListTile(List<Subtitle> subtitlesTracks) {
    final list = <PopupMenuEntry<Subtitle>>[];

    // TITLE
    list.add(PopupMenuItem(child: Text('select_subtitle'.tr())));

    if (subtitlesTracks.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('no_subtitles'.tr())));
      return list;
    }

    // If subtitles list is not empty the we show disabled button at start of list
    const disabledSubtitle = Subtitle.empty;
    list.add(
      CheckedPopupMenuItem(
        value: disabledSubtitle,
        checked: context.read<StreamCubit>().state.selectedSubtitleTrack.index == disabledSubtitle.index,
        child: Text(
          'disabled'.tr(),
        ),
      ),
    );

    // LOCAL SUBTITLES
    final localSubtitles = subtitlesTracks.where((element) => element.mediaType == MediaType.local).toList();
    list.add(PopupMenuDivider(height: 10));
    list.add(listItemTitle(
        child: Text(
      'embeded_subtitles'.tr(),
      style: Theme.of(context).textTheme.bodyMedium,
    )));

    if (localSubtitles.isEmpty) {
      list.add(
          PopupMenuItem(enabled: false, child: Align(alignment: Alignment.center, child: Text('no_subtitles'.tr()))));
    } else {
      for (var index = 0; index < localSubtitles.length; index++) {
        final subtitle = localSubtitles[index];
        list.add(
          CheckedPopupMenuItem(
            value: subtitle,
            checked: subtitle.index == context.read<StreamCubit>().state.selectedSubtitleTrack.index,
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
        style: Theme.of(context).textTheme.bodyMedium,
      )),
    );

    final remoteSubtitles = subtitlesTracks.where((element) => element.mediaType == MediaType.remote).toList();
    if (remoteSubtitles.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('no_subtitles'.tr())));
    } else {
      for (var index = 0; index < remoteSubtitles.length; index++) {
        final subtitle = remoteSubtitles[index];
        list.add(CheckedPopupMenuItem(
          value: subtitle,
          checked: subtitle.index == context.read<StreamCubit>().state.selectedSubtitleTrack.index,
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
                color: ColorUtil.darken(Theme.of(context).colorScheme.background, 0.1)),
            child: child));
  }
}
