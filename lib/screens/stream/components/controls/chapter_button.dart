import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/chapter.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';
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
    _node = FocusNode(canRequestFocus: false, descendantsAreFocusable: false);
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      node: _node,
      onPressed: () => {},
      shape: CircleBorder(),
      child: changeChapter(context),
    );
  }

  Widget changeChapter(BuildContext context) {
    return PopupMenuButton<Chapter>(
        icon: Icon(
          Icons.list,
          color: Colors.white,
        ),
        tooltip: 'Select a chapter',
        onSelected: (Chapter value) => goToChapter(value),
        itemBuilder: (context) =>
            chapterList(streamingProvider.item?.chapters));
  }

  List<PopupMenuEntry<Chapter>> chapterList(List<Chapter>? chapters) {
    final list = <PopupMenuEntry<Chapter>>[];
    list.add(
      PopupMenuItem(
        child: Text('Select a chapter'),
      ),
    );
    list.add(
      PopupMenuDivider(
        height: 10,
      ),
    );
    if (chapters == null || chapters.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('No chapters')));
      return list;
    }
    for (var index = 0; index < chapters.length; index++) {
      final chapter = chapters[index];
      list.add(chapterItem(chapter));
    }
    return list;
  }

  PopupMenuItem<Chapter> chapterItem(Chapter chapter) {
    final chapterPosition =
        Duration(microseconds: (chapter.startPositionTicks / 10).round());
    return PopupMenuItem<Chapter>(
      value: chapter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            chapter.name,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(printDuration(chapterPosition))
        ],
      ),
    );
  }

  void goToChapter(Chapter chapter) {
    final chapterPosition =
        Duration(microseconds: (chapter.startPositionTicks / 10).round());
    streamingProvider.commonStream!.seekTo(chapterPosition);
  }
}
