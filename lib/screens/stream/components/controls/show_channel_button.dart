import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/screens/stream/channel_cubit/channel_cubit.dart';
import 'package:jellyflut/screens/stream/cubit/stream_cubit.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ShowChannelButton extends StatelessWidget {
  final double? size;

  const ShowChannelButton({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamCubit, StreamState>(
        buildWhen: (previous, current) => previous.streamItem != current.streamItem,
        builder: (_, state) {
          if (state.streamItem.item.type != ItemType.TvChannel) {
            return const SizedBox();
          }
          return OutlinedButtonSelector(
            onPressed: context.read<ChannelCubit>().toggleChannelsPanel,
            shape: CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.live_tv,
                color: Theme.of(context).colorScheme.onBackground,
                size: size,
              ),
            ),
          );
        });
  }
}
