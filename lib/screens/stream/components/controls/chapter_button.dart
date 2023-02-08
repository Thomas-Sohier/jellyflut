import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import '../../cubit/stream_cubit.dart';

class ChapterButton extends StatefulWidget {
  const ChapterButton({super.key});

  @override
  State<ChapterButton> createState() => _ChapterButtonState();
}

class _ChapterButtonState extends State<ChapterButton> {
  late final GlobalKey<PopupMenuButtonState<Chapter>> _popupMenuButtonKey;

  @override
  void initState() {
    _popupMenuButtonKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: () => _popupMenuButtonKey.currentState?.showButtonMenu(),
      shape: CircleBorder(),
      child: changeChapter(context),
    );
  }

  Widget changeChapter(BuildContext context) {
    return ExcludeFocus(
      child: IgnorePointer(
        child: PopupMenuButton<Chapter>(
            key: _popupMenuButtonKey,
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            tooltip: 'select_chapter'.tr(),
            onSelected: (Chapter value) => goToChapter(value),
            itemBuilder: (_) => chapterList()),
      ),
    );
  }

  List<PopupMenuEntry<Chapter>> chapterList() {
    final chapters = context.read<StreamCubit>().state.streamItem.item.chapters;
    final list = <PopupMenuEntry<Chapter>>[];
    list.add(
      PopupMenuItem(
        child: Text('select_chapter'.tr()),
      ),
    );
    list.add(
      PopupMenuDivider(
        height: 10,
      ),
    );
    if (chapters.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('no_chapters'.tr())));
      return list;
    }
    for (var index = 0; index < chapters.length; index++) {
      final chapter = chapters[index];
      list.add(chapterItem(chapter));
    }
    return list;
  }

  PopupMenuItem<Chapter> chapterItem(Chapter chapter) {
    final chapterPosition = Duration(microseconds: (chapter.startPositionTicks / 10).round());
    return PopupMenuItem<Chapter>(
      value: chapter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            chapter.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(printDuration(chapterPosition))
        ],
      ),
    );
  }

  void goToChapter(Chapter chapter) {
    final chapterPosition = Duration(microseconds: (chapter.startPositionTicks / 10).round());
    context.read<StreamCubit>().state.controller!.seekTo(chapterPosition);
  }
}
