import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class Critics extends StatelessWidget {
  const Critics({required this.item, this.iconSize = 20});

  final Item item;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
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
            Text(item.communityRating.toString(), style: Theme.of(context).textTheme.titleMedium)
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
            Text(item.criticRating.toString(), style: Theme.of(context).textTheme.titleMedium)
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
