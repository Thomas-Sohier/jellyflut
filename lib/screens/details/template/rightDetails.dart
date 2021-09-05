import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/peoples_list.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/components/collection.dart';
import 'package:jellyflut/screens/details/template/components/action_button/like_button.dart';
import 'package:jellyflut/screens/details/template/components/action_button/manage_buton.dart';
import 'package:jellyflut/screens/details/template/components/action_button/play_button.dart';
import 'package:jellyflut/screens/details/template/components/action_button/trailer_button.dart';
import 'package:jellyflut/screens/details/template/components/action_button/viewed_button.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RightDetails extends StatelessWidget {
  final Item item;
  final Future<Color> dominantColorFuture;
  final DateFormat formatter = DateFormat('HH:mm');

  RightDetails(
      {Key? key, required this.item, required this.dominantColorFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
          ),
          Align(alignment: Alignment.centerLeft, child: actions(context)),
          SizedBox(
            height: 24,
          ),
          title(context),
          originalTitle(context),
          Row(
            children: [
              if (item.hasRatings())
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Critics(
                    item: item,
                  ),
                ),
              Spacer(),
              infos(context),
            ],
          ),
          overview(context),
          if (item.hasPeople()) peoples(context),
          Collection(item)
        ]);
  }

  Widget peoples(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Cast of ${item.name}',
              style: Theme.of(context).textTheme.headline3),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(height: 230, child: PeoplesList(item.people!)),
      ],
    );
  }

  Widget overview(BuildContext context) {
    if (item.overview == null) return Container();
    return Text(
      item.overview!,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  Widget infos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          if (item.productionYear != null)
            Text(
              item.productionYear.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          if (item.productionYear != null) separator(context),
          if (item.getDuration() != 0) duration(context)
        ],
      ),
    );
  }

  Widget duration(BuildContext context) {
    final timeEnd = formatter
        .format(DateTime.now().add(Duration(microseconds: item.getDuration())));
    final duration = printDuration(Duration(microseconds: item.getDuration()));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(duration, style: Theme.of(context).textTheme.bodyText2),
        separator(context),
        Text('Ends $timeEnd', style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }

  Widget separator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Text('|', style: Theme.of(context).textTheme.bodyText2),
    );
  }

  Widget title(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          item.name,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline3,
        ));
  }

  Widget originalTitle(BuildContext context) {
    if (item.originalTitle == null) return SizedBox();
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          item.originalTitle!,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline5,
        ));
  }

  Widget actions(BuildContext context) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    isAndroidTv;
    if (deviceType == DeviceScreenType.mobile) {
      return Column(
        children: [
          if (item.isPlayable())
            PlayButton(
              item: item,
              dominantColorFuture: dominantColorFuture,
              maxWidth: double.maxFinite,
            ),
          SizedBox(height: 10),
          LayoutBuilder(builder: (context, constraints) {
            final nbItemsPossible = (constraints.maxWidth / 150).round() > 4
                ? 4
                : (constraints.maxWidth / 150).round();
            final nbOfspacing = nbItemsPossible - 1;
            final maxWidthChild =
                (constraints.maxWidth - nbOfspacing * 10) / nbItemsPossible;
            return Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: [
                if (item.hasTrailer())
                  TrailerButton(item: item, maxWidth: maxWidthChild),
                if (item.canBeViewed())
                  ViewedButton(item: item, maxWidth: maxWidthChild),
                LikeButton(item: item, maxWidth: maxWidthChild),
                ManageButton(item: item, maxWidth: maxWidthChild)
              ],
            );
          })
        ],
      );
    }
    return Wrap(
      direction: Axis.horizontal,
      spacing: 10,
      runSpacing: 10,
      children: [
        if (item.isPlayable())
          PlayButton(item: item, dominantColorFuture: dominantColorFuture),
        if (item.hasTrailer()) TrailerButton(item: item),
        if (item.canBeViewed()) ViewedButton(item: item),
        LikeButton(item: item),
        ManageButton(item: item)
      ],
    );
  }
}
