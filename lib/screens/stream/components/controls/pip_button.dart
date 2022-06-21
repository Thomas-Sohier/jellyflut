import 'package:flutter/material.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';

class PipButton extends StatefulWidget {
  const PipButton({super.key});

  @override
  State<PipButton> createState() => _PipButtonState();
}

class _PipButtonState extends State<PipButton> {
  late final StreamingProvider streamingProvider;
  late final Future<bool> _hasPip;

  @override
  void initState() {
    super.initState();
    streamingProvider = StreamingProvider();
    _hasPip = streamingProvider.commonStream!.hasPip();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _hasPip,
        builder: (context, snapshotPip) {
          if (snapshotPip.data ?? false) {
            return Pip(onPressed: onPressed);
          }
          return const SizedBox();
        });
  }

  void onPressed() {
    try {
      streamingProvider.commonStream?.pip();
    } catch (message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Row(children: [
              Flexible(child: Text(message.toString(), maxLines: 3)),
              Icon(Icons.picture_in_picture, color: Colors.red)
            ]),
            duration: Duration(seconds: 10),
            width: 600));
    }
  }
}

class Pip extends StatelessWidget {
  final void Function() onPressed;
  const Pip({super.key, this.onPressed = _defaultAction});

  static void _defaultAction() {}

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: onPressed,
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.picture_in_picture,
          color: Colors.white,
        ),
      ),
    );
  }
}
