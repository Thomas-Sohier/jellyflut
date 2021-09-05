import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/stream/init_stream.dart';

class TrailerButton extends StatelessWidget {
  final Item item;
  final double maxWidth;

  const TrailerButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('Trailer',
        onPressed: () => playTrailer(context),
        minWidth: 40,
        maxWidth: maxWidth,
        borderRadius: 4,
        icon: Icon(Icons.movie, color: Colors.black87));
  }

  void playTrailer(BuildContext context) async {
    final url = await item.getYoutubeTrailerUrl();
    InitStreamingUrlUtil.initFromUrl(
        url: url.toString(), streamName: item.name);
  }
}
