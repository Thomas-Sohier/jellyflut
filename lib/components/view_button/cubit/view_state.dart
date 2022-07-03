part of 'view_cubit.dart';

enum ViewStatus { initial, loading, success, failure }

extension ViewStatusX on ViewStatus {
  bool get isInitial => this == ViewStatus.initial;
  bool get isLoading => this == ViewStatus.loading;
  bool get isSuccess => this == ViewStatus.success;
  bool get isFailure => this == ViewStatus.failure;
}

@JsonSerializable()
class ViewState extends Equatable {
  ViewState({this.status = ViewStatus.initial, this.isViewed = false});

  factory ViewState.fromJson(Map<String, dynamic> json) => _$ViewStateFromJson(json);

  final ViewStatus status;
  final bool isViewed;

  ViewState copyWith({ViewStatus? status, bool? isViewed}) {
    return ViewState(status: status ?? this.status, isViewed: isViewed ?? this.isViewed);
  }

  Map<String, dynamic> toJson() => _$ViewStateToJson(this);

  @override
  List<Object?> get props => [status, isViewed];
}
