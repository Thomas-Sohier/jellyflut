import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/stream/initStream.dart';

class TrailerButton extends StatelessWidget {
  final Item item;

  const TrailerButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('Trailer',
        onPressed: () => playTrailer(context),
        minWidth: 40,
        maxWidth: 150,
        borderRadius: 4,
        icon: Icon(Icons.movie, color: Colors.black87));
  }

  void playTrailer(BuildContext context) async {
    final url = await item.getYoutubeTrailerUrl();
    InitStreamingUrlUtil.initFromUrl(
        url: url.toString(), streamName: item.name);
  }
}
