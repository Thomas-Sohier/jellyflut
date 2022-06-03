import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/components/back_button.dart' as bb;
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/components/controls/audio_button_selector.dart';
import 'package:jellyflut/screens/stream/components/controls/bottom_row_player_controls.dart';
import 'package:jellyflut/screens/stream/components/controls/pip_button.dart';
import 'package:jellyflut/screens/stream/components/controls/subtitle_button_selector.dart';
import 'package:jellyflut/screens/stream/components/player_infos/player_infos.dart';
import 'package:jellyflut/shared/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';

import 'player_infos/subtitle_box.dart';
import 'player_infos/transcode_state.dart';

class CommonControls extends StatefulWidget {
  final bool isComputer;

  const CommonControls({super.key, this.isComputer = false});

  @override
  State<CommonControls> createState() => _CommonControlsState();
}

class _CommonControlsState extends State<CommonControls> {
  late final StreamingProvider streamingProvider;
  late final BehaviorSubject<bool> _visibleStreamController;
  late final Function(RawKeyEvent) listener;
  late Timer _timer;
  late Future<bool> hasPip;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _visibleStreamController = BehaviorSubject<bool>();
    streamingProvider = StreamingProvider();
    streamingProvider.commonStream?.initListener();
    hasPip = streamingProvider.commonStream!.hasPip();
    listener = (value) => _onKey(value);
    _timer = Timer(Duration(seconds: 5), () {
      _visible = false;
      _visibleStreamController.add(false);
    });
    RawKeyboard.instance.addListener(listener);
  }

  @override
  void dispose() {
    _timer.cancel();
    streamingProvider.timer?.cancel();
    RawKeyboard.instance.removeListener(listener);
    _visibleStreamController.close();
    super.dispose();
  }

  void _onKey(RawKeyEvent e) {
    if (e.runtimeType.toString() == 'RawKeyDownEvent') {
      autoHideControlHover();
      switch (e.logicalKey.debugName) {
        case 'Media Play Pause':
          if (streamingProvider.commonStream!.isPlaying()) {
            streamingProvider.commonStream!.pause();
          } else {
            streamingProvider.commonStream!.play();
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return platformBuilder();
  }

  Widget platformBuilder() {
    return ResponsiveBuilder.builder(
        mobile: defaultControls,
        tablet: defaultControls,
        desktop: desktopControls);
  }

  Widget desktopControls() {
    return MouseRegion(
        opaque: false,
        onHover: (PointerHoverEvent event) =>
            event.kind == PointerDeviceKind.mouse ? autoHideControlHover() : {},
        child: defaultControls());
  }

  Widget defaultControls() {
    return GestureDetector(
        onTap: autoHideControl,
        // onDoubleTap: () => streamingProvider.commonStream!.toggleFullscreen(),
        behavior: HitTestBehavior.translucent,
        child: LayoutBuilder(
            builder: (c, cc) => Stack(alignment: Alignment.center, children: [
                  SizedBox.expand(
                    child: visibility(
                        child: Stack(
                      children: [blackGradient(), controls()],
                    )),
                  ),
                  Positioned.fill(
                    top: cc.maxHeight * 0.6,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SubtitleBox()),
                  ),
                ])));
  }

  Widget visibility({required Widget child}) {
    return Material(
        color: Colors.transparent,
        child: StreamBuilder<bool>(
          initialData: false,
          stream: _visibleStreamController.stream,
          builder: (context, snapshot) => Visibility(
              maintainSize: false,
              maintainAnimation: false,
              maintainState: false,
              maintainInteractivity: false,
              maintainSemantics: false,
              visible: snapshot.data ?? false,
              child: child),
        ));
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
      children: [
        const SizedBox(height: 12),
        topRow(),
        const Spacer(),
        const BottomRowPlayerControls(),
        const SizedBox(height: 12)
      ],
    );
  }

  Widget topRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bb.SelectableBackButton(shadow: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ItemTitle(), ItemParentTitle()],
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: TranscodeState()),
          FutureBuilder<bool>(
              future: hasPip,
              builder: (context, snapshot) => snapshot.hasData && snapshot.data!
                  ? PipButton()
                  : const SizedBox()),
          SubtitleButtonSelector(),
          AudioButtonSelector()
        ]);
  }

  Future<void> autoHideControl() async {
    _timer.cancel();
    _visible = !_visible;
    _visibleStreamController.add(!_visible);
    _timer = Timer(Duration(seconds: 5), () {
      _visible = false;
      _visibleStreamController.add(false);
    });
  }

  Future<void> autoHideControlHover() async {
    _timer.cancel();
    if (_visible == false) {
      _visible = true;
      _visibleStreamController.add(true);
    }
    _timer = Timer(Duration(seconds: 5), () {
      _visible = false;
      _visibleStreamController.add(false);
    });
  }
}
