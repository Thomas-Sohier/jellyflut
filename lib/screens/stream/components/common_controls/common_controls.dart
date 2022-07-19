import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/subtree_builder.dart';
import 'package:jellyflut/screens/stream/components/common_controls/common_controls_desktop.dart';
import 'package:jellyflut/screens/stream/components/common_controls/common_controls_phone.dart';
import 'package:jellyflut/screens/stream/cubit/stream_cubit.dart';

class CommonControls extends StatefulWidget {
  const CommonControls({super.key});

  @override
  State<CommonControls> createState() => _CommonControlsState();
}

class _CommonControlsState extends State<CommonControls> {
  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_onKey);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_onKey);
    super.dispose();
  }

  void _onKey(RawKeyEvent e) {
    if (e.runtimeType.toString() == 'RawKeyDownEvent') {
      // context.read<StreamCubit>().autoHideControl();
      switch (e.logicalKey.debugName) {
        case 'Media Play Pause':
          context.read<StreamCubit>().togglePlay();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
          onTap: context.read<StreamCubit>().autoHideControl,
          behavior: HitTestBehavior.translucent,
          child: MouseRegion(
              opaque: false,
              onHover: (PointerHoverEvent event) =>
                  event.kind == PointerDeviceKind.mouse ? context.read<StreamCubit>().autoHideControl() : {},
              child: SubtreeBuilder(
                  builder: (_, child) => Visibility(
                      maintainSize: false,
                      maintainAnimation: false,
                      maintainState: false,
                      maintainSemantics: false,
                      maintainInteractivity: false,
                      visible: true,
                      child: child ?? const SizedBox()),
                  child: const Controls()))),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 960) {
        return const CommonControlsDesktop();
      }
      return const CommonControlsPhone();
    });
  }
}
