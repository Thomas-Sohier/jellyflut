import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/components/poster/progress_bar.dart';
import 'package:jellyflut/mixins/absorb_action.dart';
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

final _aspectRatioCache = <String, double>{};

class ItemPoster extends StatefulWidget {
  const ItemPoster(
    this.item, {
    super.key,
    this.textColor,
    this.heroTag,
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
  State<ItemPoster> createState() => _ItemPosterState();
}

class _ItemPosterState extends State<ItemPoster> {
  double? _aspectRatio;

  @override
  void initState() {
    super.initState();
    _aspectRatio =
        _aspectRatioCache[widget.item.id] ?? widget.item.getPrimaryAspectRatio(showParent: widget.showParent);
  }

  @override
  Widget build(BuildContext context) {
    final finalTextColor = widget.textColor ?? Theme.of(context).colorScheme.onSurface;

    return AsyncImageProvider(
      item: widget.item,
      imageType: widget.tag,
      showParent: widget.showParent,
      placeholder: (_) => _buildPlaceholder(),
      error: (_) => _buildPlaceholder(),
      builder: (context, imageProvider, imageInfo) {
        final image = imageInfo.image;
        if (image.height > 0) {
          final calculatedRatio = image.width / image.height;
          if (_aspectRatio != calculatedRatio) {
            _aspectRatioCache[widget.item.id] = calculatedRatio;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _aspectRatio = calculatedRatio);
              }
            });
          }
        }

        // On construit l'UI finale avec le ratio d'aspect correct
        return _buildContent(context, finalTextColor, imageProvider);
      },
    );
  }

  // Affiche un placeholder en attendant que l'image soit prête
  Widget _buildPlaceholder() {
    return AspectRatio(
      aspectRatio: _aspectRatio!, // Utilise le ratio de l'API/cache pendant le chargement
      child: Container(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
    );
  }

  // Construit l'UI finale du poster
  Widget _buildContent(BuildContext context, Color textColor, ImageProvider imageProvider) {
    return AspectRatio(
      aspectRatio: _aspectRatio!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _Poster(
                  item: widget.item,
                  imageProvider: imageProvider, // On passe l'ImageProvider
                  heroTag: widget.heroTag,
                  boxFit: widget.boxFit,
                  clickable: widget.clickable,
                ),
                if (widget.showOverlay) _PosterOverlays(item: widget.item, showLogo: widget.showLogo),
              ],
            ),
          ),
          if (widget.showName) _PosterTitle(item: widget.item, showParent: widget.showParent, textColor: textColor),
        ],
      ),
    );
  }
}

// Le widget `_Poster` est maintenant beaucoup plus simple.
// Il ne fait qu'afficher une image et gérer le clic.
class _Poster extends StatefulWidget {
  const _Poster({
    required this.item,
    required this.imageProvider,
    required this.boxFit,
    required this.clickable,
    this.heroTag,
  });

  final Item item;
  final ImageProvider imageProvider;
  final BoxFit boxFit;
  final bool clickable;
  final String? heroTag;

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
    final posterImage = Image(image: widget.imageProvider, fit: widget.boxFit);
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
          if (item.isNew) const Positioned(top: 8, left: 8, child: _NewBanner()),
          if (item.isPlayed) const Positioned(top: 8, right: 8, child: _PlayedBanner()),
          if (showLogo)
            Align(
              alignment: Alignment.center,
              child: Logo(item: item, selectable: false),
            ),
          if (item.hasProgress)
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
