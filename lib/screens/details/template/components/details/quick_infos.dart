import 'package:flutter/material.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';

class QuickInfos extends StatelessWidget {
  final Item item;
  const QuickInfos({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                if (item.hasRatings()) Critics(item: item),
                InfosDetailsWidget(item: item),
              ]),
        ),
      ],
    );
  }
}
