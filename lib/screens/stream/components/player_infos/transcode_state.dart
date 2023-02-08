import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/gradient_mask.dart';
import 'package:jellyflut/screens/stream/cubit/stream_cubit.dart';

class TranscodeState extends StatelessWidget {
  const TranscodeState({super.key});

  @override
  Widget build(BuildContext context) {
    final isTranscoding = context.read<StreamCubit>().state.streamItem.playbackInfos?.isTranscoding() ?? false;
    return DecoratedBox(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: isTranscoding ? const TranscodeIcon() : const DirectPlayIcon(),
        ));
  }

  Widget directPlayIcon(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondary;
    return Row(
      children: [
        GradientMask(
            child: Icon(
          Icons.play_for_work,
          color: color,
        )),
        const SizedBox(width: 8),
        Text(
          'Direct play',
          style: TextStyle(fontFamily: 'Poppins', color: color),
        )
      ],
    );
  }
}

class DirectPlayIcon extends StatelessWidget {
  const DirectPlayIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondary;
    return Row(
      children: [
        Icon(
          Icons.play_for_work,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          'Direct play',
          style: TextStyle(fontFamily: 'Poppins', color: color),
        )
      ],
    );
  }
}

class TranscodeIcon extends StatelessWidget {
  const TranscodeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondary;
    return Tooltip(
        enableFeedback: false,
        richMessage: generateTranscodeReasons(context.read<StreamCubit>().state.streamItem.url).textSpan,
        child: Row(
          children: [
            Icon(
              Icons.cloud_outlined,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              'Transcoding',
              style: TextStyle(fontFamily: 'Poppins', color: color),
            )
          ],
        ));
  }

  Text generateTranscodeReasons(String url) {
    // We parse query params to detect and get transcoding reasons
    // Reasons are split by ',' such as :
    // reason1,reason2,...
    final transcodeReasons = Uri.parse(url).queryParameters['TranscodeReasons']?.split(',');

    return Text.rich(TextSpan(
      text: 'Transcode reasons : ',
      children: <TextSpan>[
        ...transcodeReasons?.map((tr) => TextSpan(text: '\n - $tr')) ?? <TextSpan>[],
      ],
    ));
  }
}
