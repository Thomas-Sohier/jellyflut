import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/shared/shared.dart';

class CurrentDurationPlayer extends StatelessWidget {
  const CurrentDurationPlayer({super.key});

  StreamingProvider get streamingProvider => StreamingProvider();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: streamingProvider.commonStream?.getDurationStream(),
      initialData: Duration.zero,
      builder: (context, snapshot) {
        return Text(printDuration(snapshot.data ?? Duration.zero));
      },
    );
  }
}
