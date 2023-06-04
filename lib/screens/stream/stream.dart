import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/screens/stream/channel_cubit/channel_cubit.dart';
import 'package:jellyflut/screens/stream/components/player_interface.dart';
import 'package:jellyflut/screens/stream/cubit/stream_cubit.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:live_tv_repository/live_tv_repository.dart';
import 'package:streaming_repository/streaming_repository.dart';
import 'package:universal_io/io.dart';
import 'package:wakelock/wakelock.dart';

class StreamPage extends StatelessWidget {
  final Item? item;
  final String? url;

  const StreamPage({super.key, this.item, this.url})
      : assert(item != null || url != null, 'At least one param must be given');

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => StreamCubit(
          streamingRepository: context.read<StreamingRepository>(),
          item: item,
          url: url,
        )..init(),
      ),
      if (item?.type == ItemType.TvChannel)
        BlocProvider(
          create: (_) =>
              ChannelCubit(liveTvRepository: context.read<LiveTvRepository>())
                ..init(),
        )
    ], child: const StreamView());
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeProvider>().getThemeData;
    return Theme(
        // We force white controls on player controls to have better contrast
        data: theme.copyWith(
            colorScheme:
                theme.colorScheme.copyWith(onBackground: Colors.white)),
        child: Scaffold(
            backgroundColor: Colors.black, body: const PlayerInterface()));
  }
}
