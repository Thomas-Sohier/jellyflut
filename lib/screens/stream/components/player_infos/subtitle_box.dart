import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/streaming/streaming_event.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart'
    as stream_subtitle;
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'package:subtitle/subtitle.dart';

class SubtitleBox extends StatefulWidget {
  SubtitleBox({Key? key}) : super(key: key);

  @override
  _SubtitleBoxState createState() => _SubtitleBoxState();
}

class _SubtitleBoxState extends State<SubtitleBox> {
  late Future<SubtitleController?> subtitleControllerFuture;
  late final BehaviorSubject<String?> subtitlesStream;
  late final StreamingProvider streamingProvider;
  late final StreamSubscription<Duration>? _subPosition;
  late final StreamSubscription<StreamingEvent> _subEvent;
  late final TextStyle? subtitleStyle;

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    subtitlesStream = BehaviorSubject();
    subtitleControllerFuture = getSub(streamingProvider.selectedSubtitleTrack);
    _subPosition =
        streamingProvider.commonStream?.getPositionStream().listen((value) {});
    _subEvent = streamingProvider.streamingEvent.listen((event) {});
    _subEvent.onData(streamingEventListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subtitleStyle = Theme.of(context)
        .textTheme
        .bodyText1
        ?.copyWith(color: Colors.white)
        .copyWith(fontSize: 22);
  }

  @override
  void dispose() {
    _subPosition?.cancel();
    _subEvent.cancel();
    subtitlesStream.close();
    super.dispose();
  }

  void streamingEventListener(StreamingEvent event) {
    if (event == StreamingEvent.SUBTITLE_SELECTED) {
      subtitlesStream.add(null);
      // This works now try to make it faster
      subtitleControllerFuture =
          getSub(streamingProvider.selectedSubtitleTrack);
      subtitleControllerFuture.then(streamingPositionListener);
    }
  }

  void streamingPositionListener(SubtitleController? subtitleController) {
    if (subtitleController == null) return;

    _subPosition?.onData(
        (position) => subtitlePositionListener(subtitleController, position));
  }

  void subtitlePositionListener(
      SubtitleController subtitleController, Duration position) {
    final sub = subtitleController.durationSearch(position);
    //  .subtitles.firstWhereOrNull((s) {
    //   return s.start <= position && s.end >= position;
    // });
    if (sub != null) {
      subtitlesStream.add(sub.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: subtitlesStream.stream,
        builder: (context, ss) {
          if (ss.data != null) {
            return Container(
                alignment: Alignment.center,
                child: Text(ss.data!, style: subtitleStyle));
          }
          return const SizedBox();
        });
  }

  Future<SubtitleController?> getSub(stream_subtitle.Subtitle? subtitle) async {
    if (subtitle == null) return null;

    final subUrl = StreamingService.getSubtitleURL(
        streamingProvider.item!.id, 'vtt', subtitle.jellyfinSubtitleIndex!);

    return await Dio()
        .get<dynamic>(subUrl)
        .then<SubtitleController>((subFile) async {
      final controller = SubtitleController(
          provider: SubtitleProvider.fromString(
        data: subFile.data ?? '',
        type: SubtitleType.vtt,
      ));

      await controller.initial();
      return controller;
    }).catchError((error) {
      log(error);
    });
  }
}
