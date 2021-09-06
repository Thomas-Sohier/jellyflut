import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/components/collection.dart';
import 'package:jellyflut/screens/details/template/components/action_button/details_button_row_buider.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';

class RightDetails extends StatelessWidget {
  final Item item;
  final Future<Color> dominantColorFuture;

  RightDetails(
      {Key? key, required this.item, required this.dominantColorFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Align(
              alignment: Alignment.centerLeft,
              child: DetailsButtonRowBuilder(
                  item: item, dominantColorFuture: dominantColorFuture)),
          SizedBox(height: 24),
          Row(children: [
            TitleDetailsWidget(title: item.name),
            SizedBox(width: 8),
            RatingDetailsWidget(rating: item.officialRating),
          ]),
          OriginalTitleDetailsWidget(title: item.originalTitle),
          Row(children: [
            if (item.hasRatings())
              Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Critics(
                      item: item,
                      fontSize:
                          Theme.of(context).textTheme.bodyText2?.fontSize ??
                              16)),
            Spacer(),
            InfosDetailsWidget(item: item),
          ]),
          SizedBox(height: 12),
          TaglineDetailsWidget(item: item),
          SizedBox(height: 12),
          OverviewDetailsWidget(overview: item.overview),
          SizedBox(height: 12),
          ProvidersDetailsWidget(item: item),
          PeoplesDetailsWidget(item: item),
          Collection(item)
        ]);
  }
}
