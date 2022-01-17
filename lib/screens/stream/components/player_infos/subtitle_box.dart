import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/streaming/streaming_event.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:subtitle/subtitle.dart' hide Subtitle;

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
    subtitleControllerFuture =
        streamingProvider.getSub(streamingProvider.selectedSubtitleTrack);
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
        .copyWith(fontSize: 32);
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
          streamingProvider.getSub(streamingProvider.selectedSubtitleTrack);
      subtitleControllerFuture.then(streamingPositionListener);
    }
  }

  void streamingPositionListener(SubtitleController? subtitleController) {
    if (subtitleController == null) {
      subtitlesStream.add(null);
      _subPosition?.cancel();
      return;
    }

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
    } else {
      subtitlesStream.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: subtitlesStream.stream,
        builder: (context, ss) {
          if (ss.hasData && ss.data != null) {
            return subtitleContainer(ss.data!);
          }
          return const SizedBox();
        });
  }

  Widget subtitleContainer(String text) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Align(
          alignment: Alignment.center,
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Text(text,
                style: subtitleStyle
                    ?.copyWith(fontSize: constraints.maxHeight * 0.1)
                    .copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black,
                    )),
            Text(text,
                style: subtitleStyle?.copyWith(
                    fontSize: constraints.maxHeight * 0.1))
          ]),
        );
      },
    );
  }
}
