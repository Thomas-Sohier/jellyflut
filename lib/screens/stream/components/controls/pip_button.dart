import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class PipButton extends StatefulWidget {
  PipButton({super.key});

  @override
  State<PipButton> createState() => _PipButtonState();
}

class _PipButtonState extends State<PipButton> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;
  late final FToast fToast;

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    fToast = FToast();
    fToast.init(context);
    streamingProvider = StreamingProvider();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: () {
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
      },
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
