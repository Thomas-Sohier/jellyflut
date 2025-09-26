import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/components/poster/progress_bar.dart';
import 'package:jellyflut/mixins/absorb_action.dart';
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

/// Affiche une jaquette d'item complète, incluant l'image,
/// des superpositions optionnelles (logo, indicateurs) et un titre.
class ItemPoster extends StatelessWidget {
  const ItemPoster(
    this.item, {
    super.key,
    this.textColor,
    this.heroTag,
    this.aspectRatio,
    this.height,
    this.width,
    this.showName = true,
    this.showParent = true,
    this.showOverlay = true,
    this.showLogo = false,
    this.clickable = true,
    this.tag = ImageType.Primary,
    this.boxFit = BoxFit.cover,
  });

  final Item item;
  final String? heroTag;
  final double? aspectRatio;
  final Color? textColor;
  final double? height;
  final double? width;
  final bool showName;
  final bool showParent;
  final bool showOverlay;
  final bool showLogo;
  final bool clickable;
  final ImageType tag;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    final finalAspectRatio = aspectRatio ?? item.getPrimaryAspectRatio(showParent: showParent);
    final finalTextColor = textColor ?? Theme.of(context).colorScheme.onSurface;

    return AspectRatio(
      aspectRatio: finalAspectRatio,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _Poster(
                  item: item,
                  imageType: tag,
                  heroTag: heroTag,
                  boxFit: boxFit,
                  width: width,
                  height: height,
                  clickable: clickable,
                  showParent: showParent,
                ),
                if (showOverlay) _PosterOverlays(item: item, showLogo: showLogo),
              ],
            ),
          ),
          if (showName) _PosterTitle(item: item, showParent: showParent, textColor: finalTextColor),
        ],
      ),
    );
  }
}

/// Widget interne gérant l'image interactive (clic, focus, hover).
class _Poster extends StatefulWidget {
  const _Poster({
    required this.item,
    required this.imageType,
    required this.boxFit,
    required this.clickable,
    required this.showParent,
    this.heroTag,
    this.width,
    this.height,
  });

  final Item item;
  final ImageType imageType;
  final BoxFit boxFit;
  final bool clickable;
  final bool showParent;
  final String? heroTag;
  final double? width;
  final double? height;

  @override
  State<_Poster> createState() => _PosterState();
}

class _PosterState extends State<_Poster> with AbsorbAction {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _navigateToDetails() {
    context.router.root.push(DetailsRoute(item: widget.item, heroTag: widget.heroTag));
  }

  @override
  Widget build(BuildContext context) {
    final posterImage = AsyncImage(
      item: widget.item,
      imageType: widget.imageType,
      boxFit: widget.boxFit,
      width: widget.width,
      height: widget.height,
      showParent: widget.showParent,
    );

    final posterWithHero = widget.heroTag != null ? Hero(tag: widget.heroTag!, child: posterImage) : posterImage;

    if (!widget.clickable) {
      return posterWithHero;
    }

    return OutlinedButton(
      onPressed: () => action(_navigateToDetails),
      focusNode: _focusNode,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(width: 3, color: Theme.of(context).colorScheme.onSurface);
          }
          return BorderSide.none;
        }),
      ),
      child: posterWithHero,
    );
  }
}

/// Widget interne affichant les superpositions (nouveau, vu, logo, etc.).
class _PosterOverlays extends StatelessWidget {
  final Item item;
  final bool showLogo;

  const _PosterOverlays({required this.item, required this.showLogo});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          if (item.isNew()) const Positioned(top: 8, left: 8, child: _NewBanner()),
          if (item.isPlayed()) const Positioned(top: 8, right: 8, child: _PlayedBanner()),
          if (showLogo)
            Align(
              alignment: Alignment.center,
              child: Logo(item: item, selectable: false),
            ),
          if (item.hasProgress())
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _ProgressBarIndicator(item: item),
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget interne pour le titre et sous-titre de la jaquette.
class _PosterTitle extends StatelessWidget {
  final Item item;
  final bool showParent;
  final Color textColor;

  const _PosterTitle({required this.item, required this.showParent, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasSubtitle = item.isFolder != null && item.parentIndexNumber != null;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            showParent ? item.parentName() : item.name ?? '',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: textTheme.bodyLarge?.copyWith(fontSize: 16, color: textColor),
          ),
          if (hasSubtitle)
            Text(
              'Saison ${item.parentIndexNumber}, Épisode ${item.indexNumber}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: textTheme.bodyMedium?.copyWith(fontSize: 12, color: textColor.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

/// Indicateur de progression.
class _ProgressBarIndicator extends StatelessWidget {
  final Item item;
  const _ProgressBarIndicator({required this.item});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ProgressBar(item: item),
      ),
    );
  }
}

/// Bannière "Nouveau".
class _NewBanner extends StatelessWidget {
  const _NewBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black54, spreadRadius: 2)],
      ),
      child: const Icon(Icons.new_releases, size: 20, color: Colors.white),
    );
  }
}

/// Bannière "Vu".
class _PlayedBanner extends StatelessWidget {
  const _PlayedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black54, spreadRadius: 2)],
      ),
      child: const Icon(Icons.check, size: 20, color: Colors.white),
    );
  }
}
