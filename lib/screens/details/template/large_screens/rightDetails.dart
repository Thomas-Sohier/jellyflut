import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/components/peoplesList.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/collection.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/likeButton.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/manageButon.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/playButton.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/trailerButton.dart';
import 'package:jellyflut/shared/shared.dart';

class RightDetails extends StatelessWidget {
  final Item item;
  final Color color;
  final Color fontColor;
  final DateFormat formatter = DateFormat('HH:mm');

  RightDetails(
      {Key? key,
      required this.item,
      this.color = Colors.grey,
      this.fontColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ListView(children: [
      if (item.hasLogo()) Logo(item: item, size: mediaQuery.size),
      SizedBox(
        height: 24,
      ),
      actions(),
      SizedBox(
        height: 24,
      ),
      title(),
      infos(),
      overview(),
      if (item.hasPeople()) peoples(),
      Collection(item)
    ]);
    ;
  }

  Widget peoples() {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Cast of ${item.name}',
              style: TextStyle(color: fontColor.withAlpha(220), fontSize: 22),
            )),
        SizedBox(
          height: 8,
        ),
        SizedBox(
            height: 230,
            child: PeoplesList(item.people!, fontColor: fontColor)),
      ],
    );
  }

  Widget overview() {
    return Text(
      item.overview ?? '',
      textAlign: TextAlign.justify,
      style: TextStyle(
          fontSize: 22,
          fontFamily: 'HindMadurai',
          color: fontColor.withAlpha(210)),
    );
  }

  Widget infos() {
    final timeEnd = formatter
        .format(DateTime.now().add(Duration(microseconds: item.getDuration())));
    final duration = printDuration(Duration(microseconds: item.getDuration()));
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Critics(
            item,
            textColor: fontColor,
          ),
          Spacer(),
          Text(
            item.productionYear.toString(),
            style: TextStyle(color: fontColor, fontSize: 16),
          ),
          separator(),
          Text(duration, style: TextStyle(color: fontColor, fontSize: 16)),
          separator(),
          Text('Ends $timeEnd',
              style: TextStyle(color: fontColor, fontSize: 16)),
        ],
      ),
    );
  }

  Widget separator() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Text('|', style: TextStyle(color: fontColor, fontSize: 16)),
    );
  }

  Widget title() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          item.name,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: fontColor.withAlpha(255),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 32),
        ));
  }

  Widget actions() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 10,
      runSpacing: 10,
      children: [
        PlayButton(item: item),
        TrailerButton(item: item),
        LikeButton(item: item),
        ManageButton(item: item)
      ],
    );
  }
}
