import 'package:flutter/material.dart';
import 'package:jellyflut/components/zoomable_image/zommable_image_controller.dart';

class ZoomableImage extends StatefulWidget {
  final Widget imageWidget;
  final ZoomableImageController? zoomableImageController;
  final Color? overlay;

  const ZoomableImage(
      {super.key,
      required this.imageWidget,
      this.zoomableImageController,
      this.overlay});

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with SingleTickerProviderStateMixin {
  late final ZoomableImageController? _zoomableImageController;
  late final AnimationController _animationController;
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.zoomableImageController != null) {
      _zoomableImageController = widget.zoomableImageController!;
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.1,
      )..addListener(updateSCaleAnimation);
      _zoomableImageController!.controller = _animationController;
    } else {
      _zoomableImageController = null;
    }
  }

  @override
  void dispose() {
    _animationController.removeListener(updateSCaleAnimation);
    _animationController.dispose();
    super.dispose();
  }

  void updateSCaleAnimation() {
    if (mounted) {
      setState(() => scale = _zoomableImageController!.controller!.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      scaleImage(),
      if (widget.overlay != null)
        IgnorePointer(
            child: SizedBox.expand(
                child: ColoredBox(color: Colors.black.withAlpha(100)))),
    ]);
  }

  Widget scaleImage() {
    if (_zoomableImageController != null) {
      return Transform.scale(scale: scale, child: widget.imageWidget);
    } else {
      return widget.imageWidget;
    }
  }
}
