import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/stream/channel_cubit/channel_cubit.dart';
import 'package:jellyflut/screens/stream/cubit/stream_cubit.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ChannelPicker extends StatelessWidget {
  const ChannelPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelCubit, ChannelState>(
        buildWhen: (previous, current) => previous.showPanel != current.showPanel,
        builder: (_, state) => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: double.infinity,
              width: state.showPanel ? 300 : 0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: const _ChannelsPickerView(),
            ));
  }
}

class _ChannelsPickerView extends StatelessWidget {
  const _ChannelsPickerView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SliverPinnedHeader(child: _PinnedHeaderChannelList()),
      BlocConsumer<ChannelCubit, ChannelState>(
          listener: (_, state) {
            if (state.status == Status.failure) {
              SnackbarUtil.message(messageTitle: state.failureMessage, context: context);
            }
          },
          buildWhen: (previous, current) => previous.channels != current.channels || previous.status != current.status,
          builder: (_, state) {
            switch (state.status) {
              case Status.initial:
              case Status.loading:
                return const SliverToBoxAdapter(child: CircularProgressIndicator());
              case Status.success:
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (_, index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _ChannelListElement(index: index, channel: state.channels[index]),
                                  if (index != 100) Divider()
                                ]),
                        childCount: state.channels.length));
              default:
                return const SliverToBoxAdapter();
            }
          })
    ]);
  }
}

class _PinnedHeaderChannelList extends StatelessWidget {
  const _PinnedHeaderChannelList();

  @override
  Widget build(BuildContext context) {
    final currentChannel = context.read<StreamCubit>().state.streamItem;
    return ColoredBox(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Channels',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(height: 8),
              ExcludeFocus(
                excluding: isAndroidTv,
                child: TextField(
                  minLines: 1,
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) => changeChannel(value, context),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  controller: TextEditingController(text: currentChannel.item.channelNumber ?? '0'),
                  decoration: InputDecoration(
                      isDense: true,
                      focusColor: Theme.of(context).colorScheme.onPrimary,
                      label: Text('Channel number', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                      fillColor: Theme.of(context).colorScheme.onPrimary,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              width: 2, style: BorderStyle.solid, color: Theme.of(context).colorScheme.onPrimary)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              width: 2, style: BorderStyle.solid, color: Theme.of(context).colorScheme.onPrimary)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              width: 2, style: BorderStyle.solid, color: Theme.of(context).colorScheme.onPrimary))),
                ),
              ),
            ],
          ),
        ));
  }

  /// Method that change channel based on input. [channelNumber] can be null and the method
  /// won't change channel
  void changeChannel(String? channelNumber, BuildContext context) {
    // We check first that channel number is correctly setup
    if (channelNumber == null || int.tryParse(channelNumber) == null) {
      return SnackbarUtil.message(messageTitle: 'Input is not valid', context: context);
    }
    final channel = context
        .read<ChannelCubit>()
        .state
        .channels
        .firstWhere((element) => element.channelNumber == channelNumber, orElse: () => Item.empty);

    if (channel.isEmpty) {
      return SnackbarUtil.message(messageTitle: 'No channel match channel number : $channelNumber', context: context);
    }
    context.read<StreamCubit>().changeDataSource(item: channel);
  }
}

class _ChannelListElement extends StatelessWidget {
  final int index;
  final Item channel;

  const _ChannelListElement({required this.index, required this.channel});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: () => context.read<StreamCubit>().changeDataSource(item: channel),
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('#${channel.channelNumber} - ${channel.name}', style: Theme.of(context).textTheme.bodyLarge),
              if (channel.overview != null)
                Text('Currently : ${channel.overview}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
