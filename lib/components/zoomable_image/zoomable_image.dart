import 'package:flutter/material.dart';
import 'package:jellyflut/components/zoomable_image/zommable_image_controller.dart';

class ZoomableImage extends StatefulWidget {
  final Widget imageWidget;
  final ZoomableImageController? zoomableImageController;
  final Color? overlay;

  const ZoomableImage({super.key, required this.imageWidget, this.zoomableImageController, this.overlay});

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  double scale = 1.0;

  @override
  void didChangeDependencies() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.1,
    )..addListener(updateScaleAnimation);
    widget.zoomableImageController?.setController(_animationController);
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    widget.zoomableImageController?.dispose();
    super.deactivate();
  }

  @override
  void dispose() {
    _animationController.removeListener(updateScaleAnimation);
    _animationController.dispose();
    super.dispose();
  }

  void updateScaleAnimation() {
    if (mounted) {
      scale = _animationController.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: [
      scaleImage(),
      if (widget.overlay != null)
        IgnorePointer(child: SizedBox.expand(child: ColoredBox(color: Colors.black.withAlpha(100)))),
    ]);
  }

  Widget scaleImage() {
    if (widget.zoomableImageController != null) {
      return AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) => Transform.scale(scale: scale, child: child),
          child: widget.imageWidget);
    } else {
      return widget.imageWidget;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
