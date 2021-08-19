import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/chapter.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';
import 'package:jellyflut/shared/shared.dart';

class ChapterButton extends StatefulWidget {
  ChapterButton({Key? key}) : super(key: key);

  @override
  _ChapterButtonState createState() => _ChapterButtonState();
}

class _ChapterButtonState extends State<ChapterButton> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;

  @override
  void initState() {
    _node = FocusNode();
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      node: _node,
      onPressed: () => selectChapter(context),
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.list,
          color: Colors.white,
        ),
      ),
    );
  }

  void selectChapter(BuildContext context) {
    final chapters = streamingProvider.item?.chapters ?? [];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Select Chapter'),
              content: Container(
                  width: 250,
                  constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
                  child: ListView.builder(
                      itemCount: chapters.length,
                      itemBuilder: (context, index) =>
                          _chapterListItem(chapters.elementAt(index)))));
        });
  }

  Widget _chapterListItem(Chapter chapter) {
    final chapterPosition =
        Duration(microseconds: (chapter.startPositionTicks / 10).round());
    return ListTile(
        selected: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              chapter.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(printDuration(chapterPosition),
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .color!
                        .withAlpha(170)))
          ],
        ),
        onTap: () {
          streamingProvider.commonStream!.seekTo(chapterPosition);
          customRouter.pop();
        });
  }
}
