import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/action_button.dart';
import 'package:jellyflut/screens/settings/bloc/settings_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsBloc>().state;
    return BlocBuilder<DetailsBloc, DetailsState>(
        buildWhen: ((previous, current) =>
            previous.screenLayout != current.screenLayout),
        builder: ((context, state) {
          switch (state.screenLayout) {
            case ScreenLayout.desktop:
              if (settings.detailsPageContrasted) {
                return Padding(
                    padding: state.contentPadding,
                    child: const DesktopHeader());
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 24),
                    if (state.item.hasLogo()) Logo(item: state.item),
                    const SizedBox(height: 16),
                    Padding(
                        padding: state.contentPadding.copyWith(bottom: 10),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 50, maxWidth: double.infinity),
                            child: PlayButton(maxWidth: double.infinity))),
                  ],
                );
              }
            case ScreenLayout.mobile:
            default:
              return const MobileHeader();
          }
        }));
  }
}

class MobileHeader extends StatelessWidget {
  static const controlsOverflowSize = 20.0;
  const MobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Hero(
                    tag: state.heroTag ?? '',
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          stops: [0.7, 1],
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.background,
                            Colors.transparent
                          ],
                        ).createShader(Rect.fromLTRB(0, 0, 0, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: AsyncImage(
                        item: state.item,
                        imageType: ImageType.Primary,
                        boxFit: BoxFit.cover,
                        notFoundPlaceholder: const SizedBox(),
                        width: double.infinity,
                        borderRadius: BorderRadius.zero,
                        height: 250,
                        showOverlay: true,
                      ),
                    )),
                SizedBox(height: controlsOverflowSize)
              ],
            ),
            Positioned(
              bottom: 0,
              left: 15,
              right: 15,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 50),
                child: PlayButton(maxWidth: double.infinity),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

class DesktopHeader extends StatelessWidget {
  static const controlsOverflowSize = 20.0;
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (!state.item.hasBackrop() && !state.item.hasLogo()) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 10),
        child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: 50, maxWidth: double.infinity),
            child: PlayButton(
              maxWidth: double.infinity,
            )),
      );
    }
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                if (state.item.hasBackrop())
                  AsyncImage(
                    item: state.item,
                    imageType: ImageType.Backdrop,
                    boxFit: BoxFit.cover,
                    notFoundPlaceholder: const SizedBox(),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4)),
                    width: double.infinity,
                    height: 250,
                    showOverlay: true,
                  ),
                SizedBox(height: controlsOverflowSize)
              ],
            ),
            if (state.item.hasLogo()) Logo(item: state.item),
            Positioned(
                bottom: 0,
                left: 15,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 200),
                  child: PlayButton(maxWidth: double.infinity),
                )),
          ],
        ),
        const SizedBox(height: 24)
      ],
    );
  }
}
