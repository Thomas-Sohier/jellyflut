part of 'home_drawer_cubit.dart';

class HomeDrawerState extends Equatable {
  const HomeDrawerState({required this.currentIndexSelected, this.name = '', this.screenLayout = LayoutType.desktop});

  final String name;
  final LayoutType screenLayout;
  final int currentIndexSelected;

  HomeDrawerState copyWith({int? currentIndexSelected, String? name, LayoutType? screenLayout}) {
    return HomeDrawerState(
        currentIndexSelected: currentIndexSelected ?? this.currentIndexSelected,
        name: name ?? this.name,
        screenLayout: screenLayout ?? this.screenLayout);
  }

  @override
  List<Object?> get props => [currentIndexSelected, name, screenLayout];
}
