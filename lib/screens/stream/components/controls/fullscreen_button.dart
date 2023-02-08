import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

import '../../cubit/stream_cubit.dart';

class FullscreenButton extends StatelessWidget {
  const FullscreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: context.read<StreamCubit>().toggleFullscreen,
        shape: CircleBorder(),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<StreamCubit, StreamState>(
                buildWhen: (previous, current) => previous.fullscreen != current.fullscreen,
                builder: (_, state) {
                  return Icon(
                    state.fullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  );
                })));
  }
}
