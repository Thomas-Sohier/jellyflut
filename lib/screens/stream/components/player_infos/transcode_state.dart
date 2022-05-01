import 'package:flutter/material.dart';
import 'package:jellyflut/components/gradient_mask.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';

class TranscodeState extends StatelessWidget {
  const TranscodeState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streamingProvider = StreamingProvider();
    final isDirectPlay = streamingProvider.isDirectPlay ?? true;
    return isDirectPlay ? directPlayIcon() : transcodeIcon(streamingProvider);
  }

  Widget directPlayIcon() {
    return const GradientMask(
        child: Icon(Icons.play_for_work, color: Colors.white));
  }

  Widget transcodeIcon(streamingProvider) {
    return Tooltip(
        enableFeedback: false,
        richMessage: generateTranscodeReasons(streamingProvider).textSpan,
        child: const GradientMask(
            child: Icon(
          Icons.cloud_outlined,
          color: Colors.white,
        )));
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
