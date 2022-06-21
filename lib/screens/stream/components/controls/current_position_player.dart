import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/shared/shared.dart';

class CurrentPositionPlayer extends StatelessWidget {
  const CurrentPositionPlayer({super.key});

  StreamingProvider get streamingProvider => StreamingProvider();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: streamingProvider.commonStream?.getPositionStream(),
      initialData: Duration.zero,
      builder: (context, snapshot) {
        return Text(printDuration(snapshot.data ?? Duration.zero));
      },
    );
  }
}
