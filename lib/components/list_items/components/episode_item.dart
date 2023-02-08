import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class EpisodeItem extends StatelessWidget {
  final bool clickable;
  final Item item;
  final BoxFit boxFit;
  final Widget? notFoundPlaceholder;

  const EpisodeItem(
      {super.key, required this.item, this.notFoundPlaceholder, this.clickable = true, this.boxFit = BoxFit.cover});

  Future<void> _onTap(BuildContext context) {
    return context.router.root.push(r.DetailsPage(item: item, heroTag: ValueKey(item).toString()));
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => _onTap(context),
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          final rightPartPadding =
              constraints.maxWidth < 350 ? const EdgeInsets.only(left: 0) : const EdgeInsets.only(left: 8);
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (constraints.maxWidth > 350)
                  ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 20, maxWidth: constraints.maxWidth * 0.4), child: poster()),
                Expanded(
                  child: Padding(
                      padding: rightPartPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Title(indexNumber: item.indexNumber, name: item.name ?? ''),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: Row(
                              children: [
                                if (item.hasRatings()) Critics(item: item),
                                if (item.getDuration() != 0)
                                  _Duration(
                                    duration: item.getDuration(),
                                  )
                              ],
                            ),
                          ),
                          if (item.overview != null) _Overview(overview: item.overview!)
                        ],
                      )),
                ),
              ],
            ),
          );
        }));
  }

  Widget poster() {
    return AspectRatio(
      aspectRatio: item.getPrimaryAspectRatio(),
      child: Poster(
          key: ValueKey(item),
          imageType: ImageType.Primary,
          heroTag: ValueKey(item).toString(),
          clickable: false,
          notFoundPlaceholder: notFoundPlaceholder,
          width: double.infinity,
          height: double.infinity,
          boxFit: boxFit,
          item: item),
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
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      maxLines: 2,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold).apply(fontSizeFactor: 1.2),
    );
  }
}

class _Duration extends StatelessWidget {
  final int duration;
  const _Duration({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Text(
      printDuration(Duration(microseconds: duration)),
      maxLines: 1,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
    ));
  }
}

class _Overview extends StatelessWidget {
  final String overview;
  const _Overview({required this.overview});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
