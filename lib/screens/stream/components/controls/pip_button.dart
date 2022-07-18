import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

import '../../cubit/stream_cubit.dart';

class PipButton extends StatelessWidget {
  const PipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamCubit, StreamState>(
        buildWhen: (previous, current) => previous.hasPip != current.hasPip,
        builder: (_, state) {
          if (state.hasPip) {
            return const Pip();
          }
          return const SizedBox();
        });
  }
}

class Pip extends StatelessWidget {
  const Pip({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: () => onPressed(context),
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

  void onPressed(BuildContext context) {
    try {
      context.read<StreamCubit>().state.controller?.pip();
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
