import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/music/musicProvider.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';
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
  late final MusicProvider musicProvider;
  late final FocusNode _node;
  final List<BoxShadow> shadows = [
    BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)
  ];

  @override
  void initState() {
    _node = FocusNode();
    musicProvider = MusicProvider();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (context, mp, child) {
      return controls();
    });
  }

  Widget controls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OutlinedButtonSelector(
            onPressed: () => musicProvider.previous(),
            node: _node,
            shape: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  boxShadow: shadows,
                  shape: BoxShape.circle),
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
                stream: musicProvider.getCommonPlayer!.isPlaying(),
                builder: (context, snapshot) => OutlinedButtonSelector(
                    onPressed: () => isPlaying(snapshot.data)
                        ? musicProvider.pause()
                        : musicProvider.play(),
                    node: _node,
                    shape: CircleBorder(),
                    child: Icon(
                      isPlaying(snapshot.data) ? Icons.pause : Icons.play_arrow,
                      color: widget.color,
                      size: 42,
                    )),
              )),
        ),
        OutlinedButtonSelector(
            onPressed: () => musicProvider.next(),
            node: _node,
            shape: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  boxShadow: shadows,
                  shape: BoxShape.circle),
              child: Icon(
                Icons.skip_next,
                color: widget.color,
                size: 32,
              ),
            )),
      ],
    );
  }

  bool isPlaying(bool? isplaying) {
    if (isplaying == null) return false;
    return isplaying;
  }
}
