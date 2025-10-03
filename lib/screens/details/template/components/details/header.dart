import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/action_button.dart';
import 'package:jellyflut/screens/details/template/components/details/details_ui_model.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.select((DetailsUIModel model) => model.layout);
    if (layout.isMobile) {
      final heroTag = context.select((DetailsBloc bloc) => bloc.state.heroTag);
      final item = context.select((DetailsBloc bloc) => bloc.state.item);
      return _MobileHeader(item: item, heroTag: heroTag);
    } else {
      return const _DesktopHeader();
    }
  }
}

/// Header pour la vue Desktop.
class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 50),
        child: const PlayButton(maxWidth: double.infinity),
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  static const controlsOverflowSize = 20.0;
  final Item item;
  final String? heroTag;

  const _MobileHeader({required this.item, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Hero(
              tag: heroTag ?? '',
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    stops: const [0, 1],
                    end: Alignment.bottomCenter,
                    colors: [surfaceColor, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, 0, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: AsyncImageProvider(
                  item: item,
                  imageType: ImageType.Primary,
                  showParent: false,
                  builder: (context, imageProvider, imageInfo) {
                    return Image(image: imageProvider, height: 250, width: double.infinity, fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Logo(item: item),
              ),
            ),
            Positioned(
              bottom: -controlsOverflowSize,
              left: 15,
              right: 15,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 50),
                child: PlayButton(maxWidth: double.infinity),
              ),
            ),
          ],
        ),
        const SizedBox(height: controlsOverflowSize + 10),
      ],
    );
  }
}
