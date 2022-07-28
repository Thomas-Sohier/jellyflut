import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';

part 'home_drawer_state.dart';

class HomeDrawerCubit extends Cubit<HomeDrawerState> {
  HomeDrawerCubit({LayoutType screenLayout = LayoutType.desktop, int currentIndexSelected = 0})
      : super(HomeDrawerState(currentIndexSelected: currentIndexSelected, screenLayout: screenLayout));

  void changeCurrentDrawerSelection(final int index, final String name) {
    emit(state.copyWith(currentIndexSelected: index, name: name));
  }

  void changeViewMode(final LayoutType screenLayout) {
    if (screenLayout == state.screenLayout) return;
    emit(state.copyWith(screenLayout: screenLayout));
  }
}
