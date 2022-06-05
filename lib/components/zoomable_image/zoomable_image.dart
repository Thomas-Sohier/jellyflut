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
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.zoomableImageController != null) {
      _zoomableImageController = widget.zoomableImageController!;
      _zoomableImageController!.controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.1,
      )..addListener(() =>
          setState(() => scale = _zoomableImageController!.controller!.value));
    }
  }

  @override
  void dispose() {
    _zoomableImageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Transform.scale(scale: scale, child: widget.imageWidget),
      if (widget.overlay != null)
        IgnorePointer(
            child: SizedBox.expand(
                child: ColoredBox(color: Colors.black.withAlpha(100)))),
    ]);
  }
}
