import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/components/selectable_back_button.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/async_right_details.dart';
import 'package:jellyflut/screens/details/template/components/details/details_ui_model.dart';
import 'package:jellyflut/screens/details/template/components/details/poster.dart';
import 'package:jellyflut/screens/details/template/details_background.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:provider/provider.dart';

class LargeDetailsWrapper extends StatefulWidget {
  const LargeDetailsWrapper({super.key});

  @override
  State<LargeDetailsWrapper> createState() => _LargeDetailsWrapperState();
}

class _LargeDetailsWrapperState extends State<LargeDetailsWrapper> {
  late final DetailsUIModel _uiModel;

  @override
  void initState() {
    super.initState();
    _uiModel = DetailsUIModel();
  }

  @override
  void dispose() {
    _uiModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _uiModel,
      child: LayoutBuilderScreen(
        builder: (builderContext, constraints, type) {
          final layout = type.isMobile || type.isTablet ? ScreenLayout.mobile : ScreenLayout.desktop;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _uiModel.updateLayout(layout);
            _uiModel.updateConstraints(constraints);
          });
          return const _LargeDetails();
        },
      ),
    );
  }
}

class _LargeDetails extends StatelessWidget {
  const _LargeDetails();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.select((DetailsUIModel model) => model.layout.isMobile);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const DetailsBackground(),
        SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!isMobile)
                    const Expanded(
                      flex: 4,
                      child: Center(
                        child: Padding(padding: EdgeInsets.all(16), child: Poster()),
                      ),
                    ),
                  Expanded(flex: 6, child: const AsyncRightDetails()),
                ],
              ),
              _TopBar(),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget privé pour une meilleure lisibilité.
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final model = context.select((DetailsUIModel model) => model);
    return BlocBuilder<DetailsBloc, DetailsState>(
      buildWhen: (previous, current) => previous.pinnedHeader != current.pinnedHeader,
      builder: (_, state) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: 0,
          top: model.isPinned && model.layout.isMobile ? 15 : 0,
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SelectableBackButton(),
                if (state.item.hasLogo && !state.pinnedHeader && model.constraints.maxWidth < 960)
                  Logo(item: state.item, padding: const EdgeInsets.symmetric(vertical: 8)),
              ],
            ),
          ),
        );
      },
    );
  }
}
