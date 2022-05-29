import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

import '../action_button.dart';

class DetailsButtonRowBuilder extends StatelessWidget {
  final Item item;
  const DetailsButtonRowBuilder({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return buttonsLayout();
  }

  Widget buttonsLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonExpanded = constraints.maxWidth < 600;
        late final maxWidth;
        if (buttonExpanded) {
          maxWidth = (constraints.maxWidth - 10) / 2;
        } else {
          maxWidth = 150.0;
        }

        return Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: [
            if (item.isPlayable() && buttonExpanded)
              PlayButton(item: item, maxWidth: double.infinity),
            if (item.isPlayable() && !buttonExpanded) PlayButton(item: item),
            if (item.hasTrailer())
              TrailerButton(item: item, maxWidth: maxWidth),
            if (item.canBeViewed())
              ViewedButton(item: item, maxWidth: maxWidth),
            if (item.isDownload())
              DownloadButton(item: item, maxWidth: maxWidth),
            LikeButton(item: item, maxWidth: maxWidth),
            ManageButton(item: item, maxWidth: maxWidth)
          ],
        );
      },
    );
  }
}
