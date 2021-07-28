import 'package:flutter/material.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/components/banner/LeftBanner.dart';
import 'package:jellyflut/components/banner/RightBanner.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/components/poster/progressBar.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:uuid/uuid.dart';

class ItemPoster extends StatefulWidget {
  ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.heroTag,
      this.widgetAspectRatio,
      this.showName = true,
      this.showParent = true,
      this.showLogo = false,
      this.tag = 'Primary',
      this.boxFit = BoxFit.cover});

  final Item item;
  final double widgetAspectRatio;
  final String heroTag;
  final Color textColor;
  final bool showName;
  final bool showParent;
  final bool showLogo;
  final String tag;
  final BoxFit boxFit;

  @override
  _ItemPosterState createState() => _ItemPosterState();
}

class _ItemPosterState extends State<ItemPoster>
    with SingleTickerProviderStateMixin {
  // Dpad navigation
  FocusNode _node;
  AnimationController _controller;
  Animation<double> _animation;
  Color _focusColor;
  String posterHeroTag;

  @override
  void initState() {
    _node = FocusNode();
    posterHeroTag = widget.heroTag ?? widget.item.id + Uuid().v4();
    _focusColor = Colors.transparent;
    _node.addListener(_onFocusChange);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    super.initState();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      _controller.forward();
      setState(() {
        _focusColor = Colors.white;
      });
    } else {
      _controller.reverse();
      setState(() {
        _focusColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    super.dispose();
  }

  void _onTap(String heroTag) {
    Navigator.push(
      navigatorKey.currentContext,
      MaterialPageRoute(
          builder: (context) => Details(item: widget.item, heroTag: heroTag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: () => _onTap(posterHeroTag),
        focusNode: _node,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusElevation: 0,
        autofocus: false,
        child: isAndroidTv
            ? ScaleTransition(
                scale: _animation,
                alignment: Alignment.center,
                child: AspectRatio(
                    aspectRatio: widget.widgetAspectRatio ??
                        widget.item.getPrimaryAspectRatio(),
                    child: body(posterHeroTag, context)))
            : AspectRatio(
                aspectRatio: widget.widgetAspectRatio ??
                    widget.item.getPrimaryAspectRatio(),
                child: body(posterHeroTag, context)));
  }

  Widget body(String heroTag, BuildContext context) {
    return Column(children: [
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: widget.widgetAspectRatio ??
                  widget.item.getPrimaryAspectRatio(),
              child: Stack(fit: StackFit.expand, children: [
                Hero(
                    tag: heroTag,
                    child: Poster(
                        showParent: widget.showParent,
                        tag: widget.tag,
                        isFocus: _node.hasFocus,
                        focusColor: _focusColor,
                        boxFit: widget.boxFit,
                        item: widget.item)),
                Stack(
                  children: [
                    if (widget.item.isNew())
                      Positioned(top: 8, left: 0, child: newBanner()),
                    if (widget.item.isPlayed())
                      Positioned(top: 8, right: 0, child: playedBanner()),
                  ],
                ),
                if (widget.showLogo) logo(),
                if (widget.item.hasProgress()) progress(),
              ]),
            ),
          ],
        ),
      ),
      if (widget.showName) name()
    ]);
  }

  Widget progress() {
    return Positioned.fill(
        child: Align(alignment: Alignment.bottomCenter, child: progressBar()));
  }

  Widget logo() {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: AsyncImage(
                widget.item.correctImageId(searchType: 'logo'),
                widget.item.correctImageTags(searchType: 'logo'),
                widget.item.imageBlurHashes,
                boxFit: BoxFit.contain,
                tag: 'Logo',
              ),
            )));
  }

  Widget name() {
    return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          children: [
            Text(
              widget.showParent ? widget.item.parentName() : widget.item.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(color: widget.textColor, fontSize: 16),
            ),
            if (widget.item.isFolder != null &&
                widget.item.indexNumber != null &&
                widget.item.parentIndexNumber != null)
              Text(
                'Season ${widget.item.parentIndexNumber}, Episode ${widget.item.indexNumber}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                    color: widget.textColor.withOpacity(0.8), fontSize: 12),
              ),
          ],
        ));
  }

  Widget newBanner() {
    return CustomPaint(
        painter: LeftBanner(color: Colors.red[700]),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Text('NEW',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));
  }

  Widget playedBanner() {
    return CustomPaint(
        painter: RightBanner(color: Colors.green[700]),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )));
  }

  Widget progressBar() {
    return FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.2,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProgressBar(item: widget.item)));
  }
}
