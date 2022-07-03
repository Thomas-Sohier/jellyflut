part of 'fav_cubit.dart';

enum FavStatus { initial, loading, success, failure }

extension FavStatusX on FavStatus {
  bool get isInitial => this == FavStatus.initial;
  bool get isLoading => this == FavStatus.loading;
  bool get isSuccess => this == FavStatus.success;
  bool get isFailure => this == FavStatus.failure;
}

@JsonSerializable()
class FavState extends Equatable {
  FavState({this.status = FavStatus.initial, this.isFav = false});

  factory FavState.fromJson(Map<String, dynamic> json) => _$FavStateFromJson(json);

  final FavStatus status;
  final bool isFav;

  FavState copyWith({FavStatus? status, bool? isFav}) {
    return FavState(status: status ?? this.status, isFav: isFav ?? this.isFav);
  }

  Map<String, dynamic> toJson() => _$FavStateToJson(this);

  @override
  List<Object?> get props => [status, isFav];
}
