import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/components/poster/progress_bar.dart';
import 'package:jellyflut/mixins/absorb_action.dart';
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

final _aspectRatioCache = <String, double>{};

enum PosterFit {
  /// Le widget essaiera de remplir les contraintes du parent en utilisant [Expanded].
  expand,

  /// Le widget sera aussi petit que possible, en se basant sur la taille de son contenu.
  tight,
}

class ItemPoster extends StatefulWidget {
  const ItemPoster(
    this.item, {
    super.key,
    this.textColor,
    this.heroTag,
    this.showName = true,
    this.showParent = true,
    this.showOverlay = true,
    this.showLogo = false,
    this.clickable = true,
    this.tag = ImageType.Primary,
    this.boxFit = BoxFit.cover,
    this.fit = PosterFit.expand,
  });

  final Item item;
  final String? heroTag;
  final Color? textColor;
  final bool showName;
  final bool showParent;
  final bool showOverlay;
  final bool showLogo;
  final bool clickable;
  final ImageType tag;
  final BoxFit boxFit;
  final PosterFit fit;

  @override
  State<ItemPoster> createState() => _ItemPosterState();
}

class _ItemPosterState extends State<ItemPoster> {
  late double _aspectRatio;

  @override
  void initState() {
    super.initState();
    _aspectRatio =
        _aspectRatioCache[widget.item.id] ?? widget.item.getPrimaryAspectRatio(showParent: widget.showParent);
  }

  void _updateAspectRatio(ImageInfo imageInfo) {
    final image = imageInfo.image;
    if (image.height > 16) {
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
  }

  @override
  Widget build(BuildContext context) {
    final finalTextColor = widget.textColor ?? Theme.of(context).colorScheme.onSurface;

    // Le contenu du poster est le même dans les deux cas
    final posterContent = Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _aspectRatio,
          child: AsyncImageProvider(
            item: widget.item,
            imageType: widget.tag,
            showParent: widget.showParent,
            placeholder: (_) =>
                Container(color: Theme.of(context).colorScheme.onSurface.withAlpha(20), child: const SizedBox.expand()),
            builder: (context, imageProvider, imageInfo) {
              _updateAspectRatio(imageInfo);
              return _Poster(
                item: widget.item,
                imageProvider: imageProvider,
                heroTag: widget.heroTag,
                boxFit: widget.boxFit,
                clickable: widget.clickable,
              );
            },
          ),
        ),
        if (widget.showOverlay)
          Positioned.fill(
            child: _PosterOverlays(item: widget.item, showLogo: widget.showLogo),
          ),
      ],
    );

    final titleContent = _PosterTitle(item: widget.item, showParent: widget.showParent, textColor: finalTextColor);

    // LOGIQUE CONDITIONNELLE BASÉE SUR LE PARAMÈTRE `fit`
    if (widget.fit == PosterFit.expand) {
      // Comportement original : utiliser Expanded pour remplir l'espace
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 8, child: posterContent),
          if (widget.showName) Expanded(flex: 2, child: titleContent),
        ],
      );
    } else {
      // Nouveau comportement : utiliser MainAxisSize.min pour une hauteur minimale
      return Column(
        mainAxisSize: MainAxisSize.min, // La clé est ici !
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [posterContent, if (widget.showName) titleContent],
      );
    }
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

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
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
      return ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(4)), child: posterWithHero);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: () => action(_navigateToDetails),
          focusNode: _focusNode,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(4)), child: posterWithHero),
        ),
        if (_focusNode.hasFocus)
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 3, color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ),
      ],
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
    final hasSubtitle = item.isFolder != null && item.parentIndexNumber != null && item.indexNumber != null;
    final subtitleText = hasSubtitle ? 'Saison ${item.parentIndexNumber}, Épisode ${item.indexNumber}' : '';

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            showParent ? item.parentName() : item.name ?? '',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(fontSize: 16, color: textColor),
          ),
          Text(
            subtitleText,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: textTheme.bodyMedium?.copyWith(fontSize: 12, color: textColor.withAlpha(200)),
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
