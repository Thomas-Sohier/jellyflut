import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';
import 'package:jellyflut/screens/music_player/components/song_slider.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:octo_image/octo_image.dart';

class SongImage extends StatelessWidget {
  const SongImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.maxFinite, child: imageSingleAsync());
  }

  Widget imageSingleAsync() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            buildWhen: (previous, current) => previous.currentlyPlaying != current.currentlyPlaying,
            builder: (context, state) {
              if (state.currentlyPlaying == null) {
                return const SongImagePlaceholder();
              }
              return const AlbumImage();
            },
          ),
        )
      ],
    );
  }
}

class AlbumImage extends StatelessWidget {
  const AlbumImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (TapDownDetails details) => onTapDown(context, details),
        child: Stack(
          alignment: Alignment.center,
          children: const [
            AspectRatio(aspectRatio: 1, child: ImageFromByte()),
            Positioned.fill(child: Align(alignment: Alignment.centerLeft, child: SongSlider())),
          ],
        ));
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    final widgetWidth = context.size?.width;
    final box = context.findRenderObject() as RenderBox;
    final localOffset = box.globalToLocal(details.globalPosition);
    final posx = localOffset.dx;
    final percentWidth = posx / widgetWidth!;
    final position = musicPlayerBloc.state.duration * percentWidth;
    if (position.inMilliseconds > 0 && position < musicPlayerBloc.state.duration) {
      musicPlayerBloc.add(SeekRequested(position: position));
    }
  }
}

class ImageFromByte extends StatelessWidget {
  const ImageFromByte({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    if (musicPlayerBloc.state.currentlyPlaying == null) return const SizedBox();

    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) => previous.currentlyPlaying != current.currentlyPlaying,
        builder: (context, state) => OctoImage(
              image: MemoryImage(state.currentlyPlaying!.metadata.artworkByte),
              placeholderBuilder: (_) => const SongImagePlaceholder(),
              errorBuilder: (context, error, e) => const SongImagePlaceholder(),
              fadeInDuration: const Duration(milliseconds: 300),
              fit: BoxFit.cover,
              gaplessPlayback: true,
              alignment: Alignment.center,
            ));
  }
}

class SongImagePlaceholder extends StatelessWidget {
  const SongImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ColorUtil.darken(Theme.of(context).colorScheme.background);
    final iconColor = ColorUtil.darken(Theme.of(context).colorScheme.onBackground);
    return ColoredBox(
        color: backgroundColor,
        child: Center(
          child: Icon(
            Icons.album,
            color: iconColor,
            size: 70,
          ),
        ));
  }
}
