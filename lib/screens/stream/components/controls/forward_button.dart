import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class ForwardButton extends StatefulWidget {
  final Duration duration;
  ForwardButton({Key? key, this.duration = const Duration(seconds: 10)})
      : super(key: key);

  @override
  _ForwardButtonState createState() => _ForwardButtonState();
}

class _ForwardButtonState extends State<ForwardButton> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;

  @override
  void initState() {
    _node = FocusNode();
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      node: _node,
      onPressed: forward,
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.fast_forward,
          color: Colors.white,
        ),
      ),
    );
  }

  void forward() {
    final currentDuration =
        streamingProvider.commonStream!.getCurrentPosition();
    final seekToDuration = currentDuration + widget.duration;
    streamingProvider.commonStream!.seekTo(seekToDuration);
  }
}
