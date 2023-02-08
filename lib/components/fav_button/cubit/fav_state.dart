part of 'fav_cubit.dart';

enum FavStatus { initial, loading, success, failure }

class FavState extends Equatable {
  FavState({this.status = FavStatus.initial, this.isFav = false});

  final FavStatus status;
  final bool isFav;

  FavState copyWith({FavStatus? status, bool? isFav}) {
    return FavState(status: status ?? this.status, isFav: isFav ?? this.isFav);
  }

  @override
  List<Object?> get props => [status, isFav];
}
