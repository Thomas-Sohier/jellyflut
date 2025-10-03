import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class EpisodeItem extends StatelessWidget {
  final Item item;

  const EpisodeItem({super.key, required this.item});

  Future<void> _onTap(BuildContext context) {
    // Utilisation d'un heroTag unique pour éviter les conflits
    final heroTag = 'episode-${item.id}';
    return context.router.root.push(DetailsRoute(item: item, heroTag: heroTag));
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: () => _onTap(context),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final rightPartPadding = constraints.maxWidth < 350 ? EdgeInsets.zero : const EdgeInsets.only(left: 12);
            final heroTag = 'episode-${item.id}';
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (constraints.maxWidth > 350)
                  SizedBox(
                    width: constraints.maxWidth * 0.25,
                    child: ItemPoster(
                      item,
                      tag: ImageType.Primary,
                      heroTag: heroTag,
                      fit: PosterFit.tight,
                      showParent: false,
                      showOverlay: true,
                      showName: false,
                      clickable: false,
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: rightPartPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Title(indexNumber: item.indexNumber, name: item.name ?? ''),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              if (item.hasRatings) Critics(item: item),
                              if (item.hasRatings && item.getDuration() != 0) const SizedBox(width: 8),
                              if (item.getDuration() != 0) Expanded(child: _Duration(duration: item.getDuration())),
                            ],
                          ),
                        ),
                        if (item.overview != null && item.overview!.isNotEmpty) _Overview(overview: item.overview!),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final int? indexNumber;
  final String name;

  const _Title({this.indexNumber, required this.name});

  @override
  Widget build(BuildContext context) {
    final title = indexNumber != null ? '$indexNumber - $name' : name;
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _Duration extends StatelessWidget {
  final int duration;

  const _Duration({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Text(
      printDuration(Duration(microseconds: duration)),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _Overview extends StatelessWidget {
  final String overview;

  const _Overview({required this.overview});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(overview, textAlign: TextAlign.justify, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
