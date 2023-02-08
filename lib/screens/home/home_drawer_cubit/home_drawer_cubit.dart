import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';

part 'home_drawer_state.dart';

class HomeDrawerCubit extends Cubit<HomeDrawerState> {
  HomeDrawerCubit({DrawerLayout drawerLayout = DrawerLayout.desktop, int currentIndexSelected = 0})
      : super(HomeDrawerState(
            currentIndexSelected: currentIndexSelected,
            drawerLayout: drawerLayout,
            drawerType: drawerLayout.drawerType,
            fixDrawerType: false));

  void toggleDrawerSize() {
    if (!state.fixDrawerType) return;
    final newDrawerType = state.isCompact ? DrawerType.large : DrawerType.compact;
    emit(state.copyWith(drawerType: newDrawerType));
  }

  void toggleFixDrawerSize() {
    emit(state.copyWith(fixDrawerType: !state.fixDrawerType));
  }

  void changeCurrentDrawerSelection(final int index, final String name) {
    emit(state.copyWith(currentIndexSelected: index, name: name));
  }

  void changeViewMode(final LayoutType layoutType) {
    if (layoutType.name == state.drawerLayout.name) return;
    emit(state.copyWith(drawerLayout: DrawerLayout.fromLayoutType(layoutType)));
  }
}
