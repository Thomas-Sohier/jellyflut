import 'package:flutter/material.dart';
import 'package:jellyflut/components/gradient_mask.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';

class TranscodeState extends StatelessWidget {
  const TranscodeState({super.key});

  @override
  Widget build(BuildContext context) {
    final streamingProvider = StreamingProvider();
    final isDirectPlay = streamingProvider.isDirectPlay ?? true;
    return DecoratedBox(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: isDirectPlay
              ? directPlayIcon(context)
              : transcodeIcon(streamingProvider, context),
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

  Widget transcodeIcon(streamingProvider, BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondary;
    return Tooltip(
        enableFeedback: false,
        richMessage: generateTranscodeReasons(streamingProvider).textSpan,
        child: Row(
          children: [
            GradientMask(
                child: Icon(
              Icons.cloud_outlined,
              color: color,
            )),
            const SizedBox(width: 8),
            Text(
              'Transcoding',
              style: TextStyle(fontFamily: 'Poppins', color: color),
            )
          ],
        ));
  }

  Text generateTranscodeReasons(streamingProvider) {
    // We parse query params to detect and get transcoding reasons
    // Reasons are split by ',' such as :
    // reason1,reason2,...
    final transcodeReasons = Uri.parse(streamingProvider.url ?? '')
        .queryParameters['TranscodeReasons']
        ?.split(',');

    return Text.rich(TextSpan(
      text: 'Transcode reasons : ',
      children: <TextSpan>[
        ...transcodeReasons?.map((tr) => TextSpan(text: '\n - $tr')) ??
            <TextSpan>[],
      ],
    ));
  }
}
