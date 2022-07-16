part of 'live_tv_guide_cubit.dart';

enum LiveTvGuideStatus { initial, loading, success, failure }

@immutable
class LiveTvGuideState extends Equatable {
  const LiveTvGuideState({this.guide = const <Channel>[], this.status = LiveTvGuideStatus.initial, this.limit = 100});

  final LiveTvGuideStatus status;
  final List<Channel> guide;
  final int limit;

  LiveTvGuideState copyWith({LiveTvGuideStatus? status, List<Channel>? guide, int? limit}) {
    return LiveTvGuideState(
      status: status ?? this.status,
      guide: guide ?? this.guide,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [status, guide, limit];
}
