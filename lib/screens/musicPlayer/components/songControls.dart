import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:provider/provider.dart';

class SongControls extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  SongControls({Key? key, required this.color, required this.backgroundColor})
      : super(key: key);

  @override
  _SongControlsState createState() => _SongControlsState();
}

class _SongControlsState extends State<SongControls> {
  late MusicPlayer musicPlayer;
  List<BoxShadow> shadows = [
    BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayer>(builder: (context, mp, child) {
      musicPlayer = mp;
      return controls();
    });
  }

  Widget controls() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  boxShadow: shadows,
                  shape: BoxShape.circle),
              child: InkWell(
                onTap: () => musicPlayer.previous(),
                child: Icon(
                  Icons.skip_previous,
                  color: widget.color,
                  size: 32,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    boxShadow: shadows,
                    shape: BoxShape.circle),
                child: StreamBuilder<bool>(
                  stream: musicPlayer.getCommonPlayer!.isPlaying(),
                  builder: (context, snapshot) => InkWell(
                      onTap: () => isPlaying(snapshot.data)
                          ? musicPlayer.pause()
                          : musicPlayer.play(),
                      splashColor: Colors.green,
                      child: Icon(
                        isPlaying(snapshot.data)
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: widget.color,
                        size: 42,
                      )),
                )),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                boxShadow: shadows,
                shape: BoxShape.circle),
            child: InkWell(
              onTap: () => musicPlayer.next(),
              child: Icon(
                Icons.skip_next,
                color: widget.color,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  bool isPlaying(bool? isplaying) {
    if (isplaying == null) return false;
    return isplaying;
  }
}
