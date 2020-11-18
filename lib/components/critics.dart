import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jellyflut/models/item.dart';

class Critics extends StatelessWidget {
  Critics(this.item, {this.textColor = Colors.black});

  final Item item;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return body(item, textColor);
  }

  Widget criticRating(int rating) {
    if (rating > 50) {
      return SvgPicture.asset(
        'img/fresh.svg',
        semanticsLabel: 'Critic rating',
        height: 20,
      );
    } else {
      return SvgPicture.asset(
        'img/rotten.svg',
        semanticsLabel: 'Critic rating',
        height: 20,
      );
    }
  }

  Widget body(Item item, Color textColor) {
    return Row(children: [
      if (item.communityRating != null)
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(children: [
            Icon(
              Icons.star,
              color: Colors.yellow[700],
            ),
            Text(item.communityRating.toString(),
                style: TextStyle(fontSize: 16, color: textColor))
          ]),
        ),
      if (item.criticRating != null)
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(children: [
            criticRating(item.criticRating),
            Text(item.criticRating.toString(),
                style: TextStyle(fontSize: 16, color: textColor))
          ]),
        )
    ]);
  }
}
