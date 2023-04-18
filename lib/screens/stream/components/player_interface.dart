import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/stream/components/placeholder_screen.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

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
    return Row(children: [
      const Expanded(child: _VideoBuilder()),
      BlocBuilder<StreamCubit, StreamState>(
          buildWhen: (previous, current) =>
              previous.streamItem != current.streamItem,
          builder: (_, state) {
            if (state.streamItem.item.type == ItemType.TvChannel) {
              return const ChannelPicker();
            }
            return const SizedBox();
          })
    ]);
  }
}

/// Why this ugly widget ?
/// Well VLC player on phones need to be mounted in view to be initialized
/// So we need to have this strange setup to include video player view even if it's not
/// initialized
///
/// Maybe we could male it look better to have a more debuggable view.
/// Cross-platform video player make this a bit hard to understand
class _VideoBuilder extends StatelessWidget {
  const _VideoBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StreamCubit, StreamState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (c, state) {
          switch (state.status) {
            case StreamStatus.failure:
              context.router.pop();
              SnackbarUtil.message(
                  messageTitle: 'Failed to play item',
                  messageDetails: state.failureMessage,
                  icon: Icons.play_disabled,
                  color: Theme.of(context).colorScheme.error,
                  context: context);
              break;
            default:
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (_, state) {
          switch (state.status) {
            case StreamStatus.initial:
              return const PlaceholderScreen();
            case StreamStatus.loading:
            case StreamStatus.success:
              return const _VideoPlayerBuilder();
            default:
              return const PlaceholderScreen();
          }
        });
  }
}

class _VideoPlayerBuilder extends StatelessWidget {
  const _VideoPlayerBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamCubit, StreamState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (_, state) {
          final isLoaded = state.status == StreamStatus.success;
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              if (!isLoaded) const PlaceholderScreen(),
              Visibility(
                  visible: isLoaded,
                  maintainState: true,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      const Controllerbuilder(),
                      if (isLoaded) const CommonControls()
                    ],
                  ))
            ],
          );
        });
  }
}
