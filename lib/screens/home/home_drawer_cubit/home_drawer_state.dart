part of 'home_drawer_cubit.dart';

enum DrawerType {
  compact,
  large;

  bool get isCompact => this == compact;
}

enum DrawerLayout {
  mobile(DrawerType.large, 300),
  tablet(DrawerType.compact, 75),
  androidTv(DrawerType.compact, 75),
  desktop(DrawerType.large, 300);

  final DrawerType drawerType;
  final double width;

  const DrawerLayout(this.drawerType, this.width);

  static DrawerLayout fromLayoutType(LayoutType layoutType) {
    return DrawerLayout.values.firstWhere((element) => element.name == layoutType.name);
  }

  bool get isMobile => this == mobile;
  bool get isTablet => this == tablet;
  bool get isDesktop => this == desktop;
  bool get isAndroidTv => this == androidTv;

  bool get isCompact => drawerType.isCompact;
  bool get isLarge => !drawerType.isCompact;
}

class HomeDrawerState extends Equatable {
  const HomeDrawerState(
      {required this.currentIndexSelected,
      this.name = '',
      required this.drawerLayout,
      required this.drawerType,
      this.fixDrawerType = false});

  final String name;
  final DrawerLayout drawerLayout;

  /// override current configuration of drawer
  final bool fixDrawerType;
  final int currentIndexSelected;

  /// Only used if [fixDrawerType] is set to true
  final DrawerType drawerType;

  bool get isCompact {
    if (fixDrawerType) return drawerType.isCompact;
    return drawerLayout.isCompact;
  }

  double get getDrawerWidth {
    if (!fixDrawerType) return drawerLayout.width;
    if (fixDrawerType) {
      if (drawerType == DrawerType.large) return 300;
      if (drawerType == DrawerType.compact) return 75;
    }
    return drawerLayout.width;
  }

  HomeDrawerState copyWith(
      {int? currentIndexSelected,
      String? name,
      DrawerLayout? drawerLayout,
      DrawerType? drawerType,
      bool? fixDrawerType}) {
    return HomeDrawerState(
        currentIndexSelected: currentIndexSelected ?? this.currentIndexSelected,
        name: name ?? this.name,
        drawerType: drawerType ?? this.drawerType,
        drawerLayout: drawerLayout ?? this.drawerLayout,
        fixDrawerType: fixDrawerType ?? this.fixDrawerType);
  }

  @override
  List<Object?> get props => [currentIndexSelected, name, drawerLayout, drawerType, fixDrawerType];
}
