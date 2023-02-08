import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:subtitle/subtitle.dart' hide Subtitle;

import '../../cubit/stream_cubit.dart';

class SubtitleBox extends StatefulWidget {
  const SubtitleBox({super.key});

  @override
  State<SubtitleBox> createState() => _SubtitleBoxState();
}

class _SubtitleBoxState extends State<SubtitleBox> {
  late final BehaviorSubject<String?> subtitlesStream = BehaviorSubject();
  late final StreamSubscription<Duration> positionstream;

  @override
  void initState() {
    super.initState();
    positionstream = context.read<StreamCubit>().state.controller!.getPositionStream().listen((value) {});
  }

  @override
  void dispose() {
    subtitlesStream.close();
    super.dispose();
  }

  void streamingEventListener() {
    subtitlesStream.add(null);
    // This works now try to make it faster
    // final subtitleControllerFuture =
    //     context.read<StreamCubit>().get(context.read<StreamCubit>().state.selectedSubtitleTrack);
    // subtitleControllerFuture.then(streamingPositionListener);
  }

  void streamingPositionListener(SubtitleController? subtitleController) {
    if (subtitleController == null) {
      subtitlesStream.add(null);
      positionstream.cancel();
      return;
    }

    positionstream.onData((position) => subtitlePositionListener(subtitleController, position));
  }

  void subtitlePositionListener(SubtitleController subtitleController, Duration position) {
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
    return BlocListener<StreamCubit, StreamState>(
      listener: (_, state) => streamingEventListener(),
      listenWhen: (previous, current) => previous.selectedSubtitleTrack != current.selectedSubtitleTrack,
      child: StreamBuilder<String?>(
          stream: subtitlesStream.stream,
          builder: (_, ss) {
            if (ss.hasData && ss.data != null) {
              return SubtitleContainer(text: ss.data);
            }
            return const SizedBox();
          }),
    );
  }
}

class SubtitleContainer extends StatelessWidget {
  final String? text;
  const SubtitleContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox();
    return LayoutBuilder(
      builder: (_, constraints) {
        return Align(
          alignment: Alignment.center,
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Text(text!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white)
                    .copyWith(fontSize: constraints.maxHeight * 0.1)
                    .copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black,
                    )),
            Text(text!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white)
                    .copyWith(fontSize: constraints.maxHeight * 0.1))
          ]),
        );
      },
    );
  }
}
