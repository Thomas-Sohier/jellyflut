import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/outlined_button_selector.dart';

import '../../cubit/stream_cubit.dart';

class BackwardButton extends StatelessWidget {
  final double? size;
  const BackwardButton({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: context.read<StreamCubit>().goBackward,
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.fast_rewind,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}
