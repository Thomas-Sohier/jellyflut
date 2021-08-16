import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jellyflut/models/item.dart';

class Critics extends StatelessWidget {
  const Critics({required this.item, this.fontSize = 16, this.iconSize = 20});

  final Item item;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (item.communityRating != null)
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(children: [
            Icon(
              Icons.star,
              color: Colors.yellow[700],
            ),
            SizedBox(
              width: 4,
            ),
            Text(item.communityRating.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: fontSize))
          ]),
        ),
      if (item.criticRating != null)
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(children: [
            criticRating(item.criticRating!),
            SizedBox(
              width: 4,
            ),
            Text(item.criticRating.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: fontSize))
          ]),
        )
    ]);
  }

  Widget criticRating(int rating) {
    if (rating > 50) {
      return SvgPicture.asset(
        'img/fresh.svg',
        semanticsLabel: 'Critic rating',
        height: iconSize,
      );
    } else {
      return SvgPicture.asset(
        'img/rotten.svg',
        semanticsLabel: 'Critic rating',
        height: iconSize,
      );
    }
  }
}
