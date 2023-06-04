import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/components/selectable_back_button.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/async_right_details.dart';
import 'package:jellyflut/screens/details/template/components/details/poster.dart';
import 'package:jellyflut/screens/details/template/details_background.dart';

class LargeDetails extends StatelessWidget {
  const LargeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      const DetailsBackground(),
      LayoutBuilderScreen(builder: ((_, constraints, type) {
        // Constraint emitter
        if (type.isMobile || type.isTablet) {
          BlocProvider.of<DetailsBloc>(context)
              .add(DetailsScreenSizeChanged(screenLayout: ScreenLayout.mobile));
        } else {
          BlocProvider.of<DetailsBloc>(context).add(
              DetailsScreenSizeChanged(screenLayout: ScreenLayout.desktop));
        }

        return SafeArea(
            child: Stack(alignment: Alignment.topCenter, children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                leftDetailsPart(type),
                rightDetailsPart(),
              ]),
          BlocBuilder<DetailsBloc, DetailsState>(
              buildWhen: (previous, current) =>
                  previous.pinnedHeader != current.pinnedHeader ||
                  previous.screenLayout != current.screenLayout,
              builder: (_, state) => AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  left: 0,
                  top: state.pinnedHeader && state.screenLayout.isMobile
                      ? 15
                      : 0,
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        const SelectableBackButton(),
                        if (state.item.hasLogo() &&
                            !state.pinnedHeader &&
                            constraints.maxWidth < 960)
                          Logo(
                              item: context.read<DetailsBloc>().state.item,
                              padding: EdgeInsets.symmetric(vertical: 8))
                      ],
                    ),
                  )))
        ]));
      }))
    ]);
  }

  Widget leftDetailsPart(LayoutType type) {
    return BlocBuilder<DetailsBloc, DetailsState>(builder: (_, state) {
      switch (state.screenLayout) {
        case ScreenLayout.desktop:
          return const Expanded(
              flex: 4,
              child: Center(
                  child:
                      Padding(padding: EdgeInsets.all(16), child: Poster())));

        default:
          return const SizedBox();
      }
    });
  }

  Widget rightDetailsPart() {
    return const Expanded(flex: 6, child: AsyncRightDetails());
  }
}
