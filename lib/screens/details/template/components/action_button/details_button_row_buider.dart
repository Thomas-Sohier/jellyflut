import 'package:flutter/material.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

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
            if (item.isPlayableOrCanHavePlayableChilren() && buttonExpanded)
              PlayButton(item: item, maxWidth: double.infinity),
            if (item.isPlayableOrCanHavePlayableChilren() && !buttonExpanded) PlayButton(item: item),
            if (item.hasTrailer()) TrailerButton(item: item, maxWidth: maxWidth),
            if (item.isViewable()) ViewedButton(item: item, maxWidth: maxWidth),
            if (item.isDownloable()) DownloadButton(item: item, maxWidth: maxWidth),
            LikeButton(item: item, maxWidth: maxWidth),
            const ManageButton()
          ],
        );
      },
    );
  }
}
