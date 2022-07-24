part of 'channel_cubit.dart';

enum Status { initial, loading, success, failure }

@immutable
class ChannelState extends Equatable {
  const ChannelState(
      {this.showPanel = false, this.status = Status.initial, this.channels = const <Item>[], this.failureMessage = ''});

  final Status status;
  final bool showPanel;
  final List<Item> channels;
  final String failureMessage;

  ChannelState copyWith({Status? status, bool? showPanel, List<Item>? channels, String? failureMessage}) {
    return ChannelState(
        status: status ?? this.status,
        showPanel: showPanel ?? this.showPanel,
        channels: channels ?? this.channels,
        failureMessage: failureMessage ?? this.failureMessage);
  }

  @override
  List<Object?> get props => [status, showPanel, channels, failureMessage];
}
