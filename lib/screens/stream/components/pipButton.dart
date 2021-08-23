import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';
import 'package:jellyflut/shared/toast.dart';

class PipButton extends StatefulWidget {
  PipButton({Key? key}) : super(key: key);

  @override
  _PipButtonState createState() => _PipButtonState();
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
      node: _node,
      onPressed: () {
        try {
          streamingProvider.commonStream?.pip();
        } catch (message) {
          showToast(message.toString(), fToast);
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
