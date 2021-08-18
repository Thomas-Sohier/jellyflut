import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/components/BackButton.dart' as bb;
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/screens/stream/components/bottomRowPlayerControls.dart';
import 'package:jellyflut/screens/stream/components/audioButtonSelector.dart';
import 'package:jellyflut/screens/stream/components/pipButton.dart';
import 'package:jellyflut/screens/stream/components/subtitleButtonSelector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';

class CommonControls extends StatefulWidget {
  final bool isComputer;

  const CommonControls({Key? key, this.isComputer = false}) : super(key: key);

  @override
  _CommonControlsState createState() => _CommonControlsState();
}

class _CommonControlsState extends State<CommonControls> {
  late final StreamingProvider streamingProvider;
  late Timer _timer;
  late Future<bool> hasPip;
  bool _visible = true;

  // mask layer
  final Shader linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [jellyLightBLue, jellyLightPurple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    super.initState();
    streamingProvider = StreamingProvider();
    streamingProvider.commonStream?.initListener();
    hasPip = streamingProvider.commonStream!.hasPip();
    RawKeyboard.instance.addListener((value) => _onKey(value));
    _timer = Timer(
        Duration(seconds: 5),
        () => setState(() {
              _visible = false;
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    streamingProvider.timer?.cancel();
    super.dispose();
  }

  void _onKey(RawKeyEvent e) {
    if (e.runtimeType.toString() == 'RawKeyDownEvent') {
      autoHideControlHover();
      switch (e.logicalKey.debugName) {
        case 'Media Play Pause':
          setState(() {
            if (streamingProvider.commonStream!.isPlaying()) {
              streamingProvider.commonStream!.pause();
            } else {
              streamingProvider.commonStream!.play();
            }
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: streamingProvider,
      child: MouseRegion(
          onHover: (PointerHoverEvent event) =>
              event.kind == PointerDeviceKind.mouse
                  ? autoHideControlHover()
                  : {},
          child: GestureDetector(
              onTap: () => autoHideControl(),
              behavior: HitTestBehavior.translucent,
              child: visibility(
                  child: Stack(
                children: [blackGradient(), controls()],
              )))),
    );
  }

  Widget visibility({required Widget child}) {
    return Material(
        color: Colors.transparent,
        child: Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: _visible,
            child: child));
  }

  Widget blackGradient() {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black87,
            Colors.transparent,
            Colors.transparent,
            Colors.black54
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.3, 0.8, 1],
        ),
      ),
    );
  }

  Widget controls() {
    return Column(
      children: [topRow(), Spacer(), BottomRowPlayerControls()],
    );
  }

  Widget topRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.isComputer) bb.BackButton(shadow: true),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                itemTitle(),
                streamingProvider.item!.hasParent()
                    ? itemParentTitle()
                    : Container(),
              ],
            ),
          ),
          Spacer(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: streamingProvider.isDirectPlay!
                  ? gradientMask(
                      child: Icon(Icons.play_for_work, color: Colors.white))
                  : gradientMask(
                      child: Icon(
                      Icons.cloud_outlined,
                      color: Colors.white,
                    ))),
          FutureBuilder<bool>(
              future: hasPip,
              builder: (context, snapshot) => snapshot.hasData && snapshot.data!
                  ? PipButton()
                  : Container()),
          SubtitleButtonSelector(),
          AudioButtonSelector()
        ]);
  }

  Widget itemTitle() {
    if (streamingProvider.item == null) return SizedBox();
    return Text(
      streamingProvider.item!.name,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
    );
  }

  Widget itemParentTitle() {
    if (streamingProvider.item == null) return SizedBox();
    return Text(
      streamingProvider.item!.parentName(),
      textAlign: TextAlign.left,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          foreground: Paint()..shader = linearGradient,
          fontSize: 14),
    );
  }

  Future<void> autoHideControl() async {
    _timer.cancel();
    setState(() {
      _visible = !_visible;
    });
    _timer = Timer(
        Duration(seconds: 5),
        () => setState(() {
              _visible = false;
            }));
  }

  Future<void> autoHideControlHover() async {
    _timer.cancel();
    if (_visible == false) {
      setState(() => _visible = true);
    }
    _timer = Timer(
        Duration(seconds: 5),
        () => setState(() {
              _visible = false;
            }));
  }
}
