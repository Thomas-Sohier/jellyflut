import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/stream/components/player_interface.dart';
import 'package:jellyflut/screens/stream/cubit/stream_cubit.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:streaming_repository/streaming_repository.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/screens/stream/components/placeholder_screen.dart';
import 'package:wakelock/wakelock.dart';

class StreamPage extends StatelessWidget {
  final Item? item;
  final String? url;

  const StreamPage({super.key, this.item, this.url})
      : assert(item != null || url != null, 'At least one param must be given');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StreamCubit(
        itemsRepository: context.read<ItemsRepository>(),
        streamingRepository: context.read<StreamingRepository>(),
        item: item,
        url: url,
      )..init(),
      child: const StreamView(),
    );
  }
}

class StreamView extends StatefulWidget {
  const StreamView();

  @override
  State<StreamView> createState() => _StreamViewState();
}

class _StreamViewState extends State<StreamView> {
  late final StreamCubit streamCubit;

  @override
  void initState() {
    super.initState();
    streamCubit = context.read<StreamCubit>();
    if (!Platform.isLinux) {
      Wakelock.enable();
    }

    // Hide device overlays
    // device orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    streamCubit.disposePlayer();
    if (!Platform.isLinux) {
      Wakelock.disable();
    }

    // Show device overlays
    // device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<StreamCubit, StreamState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (c, state) {
            switch (state.status) {
              case StreamStatus.success:
                context.read<StreamCubit>().play();
                break;
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
              case StreamStatus.loading:
                return const PlaceholderScreen();
              case StreamStatus.success:
                return const Center(child: PlayerInterface());

              default:
                return const PlaceholderScreen();
            }
          },
        ));
  }
}
