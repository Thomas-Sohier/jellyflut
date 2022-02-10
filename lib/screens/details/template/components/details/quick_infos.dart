import 'package:flutter/material.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';

class QuickInfos extends StatelessWidget {
  final Item item;
  const QuickInfos({Key? key, required this.item}) : super(key: key);

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
                if (item.hasRatings())
                  Critics(
                      item: item,
                      fontSize:
                          Theme.of(context).textTheme.bodyText2?.fontSize ??
                              16),
                // Spacer(),
                InfosDetailsWidget(item: item),
              ]),
        ),
      ],
    );
  }
}
