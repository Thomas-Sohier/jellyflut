import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/components/common_controls/common_controls_desktop.dart';
import 'package:jellyflut/screens/stream/components/common_controls/common_controls_phone.dart';

class CommonControls extends StatefulWidget {
  final bool isComputer;

  const CommonControls({super.key, this.isComputer = false});

  @override
  State<CommonControls> createState() => _CommonControlsState();
}

class _CommonControlsState extends State<CommonControls> {
  final ValueNotifier<bool> _visible = ValueNotifier(false);
  late final StreamingProvider streamingProvider;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    streamingProvider = StreamingProvider();
    _timer = Timer(Duration(seconds: 5), () => _visible.value = false);
    RawKeyboard.instance.addListener(_onKey);
  }

  @override
  void dispose() {
    _timer.cancel();
    streamingProvider.timer?.cancel();
    RawKeyboard.instance.removeListener(_onKey);
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
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox.expand(
        child: GestureDetector(
            onTap: autoHideControl,
            behavior: HitTestBehavior.translucent,
            child: MouseRegion(
                opaque: false,
                onHover: (PointerHoverEvent event) =>
                    event.kind == PointerDeviceKind.mouse
                        ? autoHideControlHover()
                        : {},
                child: ValueListenableBuilder<bool>(
                    builder: (context, value, child) {
                      return Visibility(
                          visible: value, child: child ?? const SizedBox());
                    },
                    valueListenable: _visible,
                    child: const Controls()))),
      );
    });
  }

  Future<void> autoHideControl() async {
    _timer.cancel();
    _visible.value = !_visible.value;
    _timer = Timer(Duration(seconds: 5), () => _visible.value = false);
  }

  Future<void> autoHideControlHover() async {
    _timer.cancel();
    if (_visible.value == false) {
      _visible.value = true;
    }
    _timer = Timer(Duration(seconds: 5), () => _visible.value = false);
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 960) {
        return CommonControlsDesktop();
      }
      return CommonControlsPhone();
    });
  }
}
