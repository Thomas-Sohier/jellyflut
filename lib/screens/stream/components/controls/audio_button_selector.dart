import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:streaming_repository/streaming_repository.dart';

import '../../cubit/stream_cubit.dart';

class AudioButtonSelector extends StatefulWidget {
  const AudioButtonSelector({super.key});

  @override
  State<AudioButtonSelector> createState() => _AudioButtonSelectorState();
}

class _AudioButtonSelectorState extends State<AudioButtonSelector> {
  late final GlobalKey<PopupMenuButtonState<AudioTrack>> _popupMenuButtonKey;

  @override
  void initState() {
    super.initState();
    _popupMenuButtonKey = GlobalKey();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => _popupMenuButtonKey.currentState?.showButtonMenu(),
        shape: CircleBorder(),
        child: changeAudioTrack(context));
  }

  Widget changeAudioTrack(BuildContext context) {
    final audioTracks = context.read<StreamCubit>().state.audioTracks;
    return ExcludeFocus(
        child: IgnorePointer(
      child: PopupMenuButton<AudioTrack>(
          key: _popupMenuButtonKey,
          icon: Icon(
            Icons.audiotrack,
            color: Colors.white,
          ),
          tooltip: 'select_audio_source'.tr(),
          onSelected: context.read<StreamCubit>().setAudioStreamIndex,
          itemBuilder: (context) {
            return _audioTracksListTile(audioTracks);
          }),
    ));
  }

  List<PopupMenuEntry<AudioTrack>> _audioTracksListTile(List<AudioTrack> audioTracks) {
    final list = <PopupMenuEntry<AudioTrack>>[];

    // TITLE
    list.add(PopupMenuItem(child: Text('select_audio_source'.tr())));

    if (audioTracks.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('no_audio_source'.tr())));
      return list;
    }

    // If audio tracks list is not empty the we show disabled button at start of list
    const disabledAudioTrack = AudioTrack.empty;
    list.add(
      CheckedPopupMenuItem(
        value: disabledAudioTrack,
        checked: context.read<StreamCubit>().state.selectedAudioTrack.index == disabledAudioTrack.index,
        child: Text(
          'default'.tr(),
        ),
      ),
    );

    // LOCAL AUDIO TRACKS
    final localAudioTracks = audioTracks.where((element) => element.mediaType == MediaType.local).toList();
    list.add(PopupMenuDivider(height: 10));
    list.add(listItemTitle(
        child: Text(
      'embeded_audio_tracks'.tr(),
      style: Theme.of(context).textTheme.bodyMedium,
    )));

    if (localAudioTracks.isEmpty) {
      list.add(PopupMenuItem(
          enabled: false,
          child: Align(
            alignment: Alignment.center,
            child: Text('no_audio_source'.tr()),
          )));
    } else {
      for (var index = 0; index < localAudioTracks.length; index++) {
        final audioTrack = localAudioTracks.elementAt(index);
        list.add(
          CheckedPopupMenuItem(
            value: audioTrack,
            checked: audioTrack.index == context.read<StreamCubit>().state.selectedAudioTrack.index,
            child: Text(audioTrack.name),
          ),
        );
      }
    }

    // REMOTE AUDIO TRACKS
    list.add(PopupMenuDivider(height: 10));
    list.add(
      listItemTitle(
          child: Text(
        'remote_audio_tracks'.tr(),
        style: Theme.of(context).textTheme.bodyMedium,
      )),
    );

    final remoteAudioTracks = audioTracks.where((element) => element.mediaType == MediaType.remote).toList();
    if (remoteAudioTracks.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('no_audio_source'.tr())));
    } else {
      for (var index = 0; index < remoteAudioTracks.length; index++) {
        final audioTrack = remoteAudioTracks.elementAt(index);
        list.add(CheckedPopupMenuItem(
          value: audioTrack,
          checked: audioTrack.index == context.read<StreamCubit>().state.selectedAudioTrack.index,
          child: Text(audioTrack.name),
        ));
      }
    }

    return list;
  }

  PopupMenuEntry<AudioTrack> listItemTitle({required Widget child}) {
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
