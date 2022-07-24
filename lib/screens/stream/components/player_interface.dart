import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/stream_cubit.dart';
import 'common_controls/common_controls.dart';
import 'controller_builder/controller_builder.dart';
import 'controls/channels_picker.dart';

class PlayerInterface extends StatefulWidget {
  const PlayerInterface({super.key});

  @override
  State<PlayerInterface> createState() => _PlayerInterfaceState();
}

class _PlayerInterfaceState extends State<PlayerInterface> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamCubit, StreamState>(
        buildWhen: (previous, current) => previous.controller != current.controller,
        builder: (_, state) {
          switch (state.status) {
            case StreamStatus.initial:
            case StreamStatus.loading:
              return const SizedBox();
            case StreamStatus.success:
              return Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: const <Widget>[
                        Controllerbuilder(),
                        CommonControls(),
                      ],
                    ),
                  ),
                  const ChannelPicker()
                ],
              );
            default:
              return const SizedBox();
          }
        });
  }
}
