part of 'home_drawer_cubit.dart';

class HomeDrawerState extends Equatable {
  const HomeDrawerState({required this.currentIndexSelected, this.screenLayout = LayoutType.desktop});

  final int currentIndexSelected;
  final LayoutType screenLayout;

  HomeDrawerState copyWith({int? currentIndexSelected, LayoutType? screenLayout}) {
    return HomeDrawerState(
        currentIndexSelected: currentIndexSelected ?? this.currentIndexSelected,
        screenLayout: screenLayout ?? this.screenLayout);
  }

  @override
  List<Object?> get props => [currentIndexSelected, screenLayout];
}
