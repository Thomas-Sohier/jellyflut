import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/components/poster/progress_bar.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:uuid/uuid.dart';

class ItemPoster extends StatefulWidget {
  const ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.heroTag,
      this.widgetAspectRatio,
      this.height,
      this.width,
      this.imagefilter = false,
      this.showName = true,
      this.showParent = true,
      this.showOverlay = true,
      this.showLogo = false,
      this.clickable = true,
      this.tag = ImageType.PRIMARY,
      this.boxFit = BoxFit.cover});

  final Item item;
  final String? heroTag;
  final double? widgetAspectRatio;
  final Color textColor;
  final bool imagefilter;
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
  _ItemPosterState createState() => _ItemPosterState();
}

class _ItemPosterState extends State<ItemPoster>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // bool properties to show hide title accordingly
  bool hasTitle = true;
  bool hasSubTitle = false;

  // bool properties to grow/shrink title/poster size accordingly
  int posterFlexSize = 9;
  int posterNameFlexSize = 1;

  // Dpad navigation
  late final FocusNode _node;
  late final String posterHeroTag;
  late final double aspectRatio;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _node = FocusNode();
    updatePosterProperties();
    // hero tag setter
    posterHeroTag = widget.heroTag ?? widget.item.id + Uuid().v4();
    aspectRatio = widget.widgetAspectRatio ??
        widget.item.getPrimaryAspectRatio(showParent: widget.showParent);
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    updatePosterProperties();
    return AspectRatio(aspectRatio: aspectRatio, child: body(context));
  }

  Widget body(BuildContext context) {
    return Column(children: [
      Flexible(
        flex: 8,
        child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Stack(children: [
                Poster(
                    showParent: widget.showParent,
                    tag: widget.tag,
                    clickable: widget.clickable,
                    heroTag: posterHeroTag,
                    boxFit: widget.boxFit,
                    width: widget.width,
                    height: widget.height,
                    item: widget.item),
                if (widget.imagefilter)
                  IgnorePointer(
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(
                              color: Colors.black.withAlpha(100)))),
                if (widget.showOverlay)
                  IgnorePointer(
                      child: Stack(
                    children: [
                      if (widget.item.isNew())
                        Positioned(top: 8, left: 8, child: newBanner()),
                      if (widget.item.isPlayed())
                        Positioned(top: 8, right: 8, child: playedBanner()),
                    ],
                  )),
                if (widget.showLogo && widget.showOverlay)
                  IgnorePointer(
                      child: Align(
                    alignment: Alignment.center,
                    child: Logo(item: widget.item),
                  )),
                if (widget.item.hasProgress() && widget.showOverlay) progress(),
              ]),
            )),
      ),
      if (hasTitle) name()
    ]);
  }

  Widget progress() {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(child: progressBar())));
  }

  Widget name() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            widget.showParent ? widget.item.parentName() : widget.item.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            softWrap: false,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 16, color: widget.textColor),
          ),
        ),
        if (hasSubTitle)
          Text(
            'Season ${widget.item.parentIndexNumber}, Episode ${widget.item.indexNumber}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 12, color: widget.textColor),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget newBanner() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.blue.shade700,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(blurRadius: 4, color: Colors.black54, spreadRadius: 2)
          ]),
      child: Icon(
        Icons.new_releases,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  Widget playedBanner() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.green.shade700,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(blurRadius: 4, color: Colors.black54, spreadRadius: 2)
          ]),
      child: Icon(
        Icons.check,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  Widget progressBar() {
    return FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.2,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProgressBar(item: widget.item)));
  }

  void updatePosterProperties() {
    hasTitle = widget.showName;
    hasSubTitle =
        widget.item.isFolder != null && widget.item.parentIndexNumber != null;

    if (hasTitle && hasSubTitle) {
      posterFlexSize = 8;
      posterNameFlexSize = 2;
    } else if (hasTitle && !hasSubTitle) {
      posterFlexSize = 9;
      posterNameFlexSize = 1;
    } else if (!hasTitle && !hasSubTitle) {
      posterFlexSize = 10;
      posterNameFlexSize = 0;
    }
  }
}
