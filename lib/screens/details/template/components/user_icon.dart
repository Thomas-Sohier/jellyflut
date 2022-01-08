import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/globals.dart';

class UserIcon extends StatelessWidget {
  final double size;

  const UserIcon({Key? key, this.size = 28}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: CachedNetworkImage(
        imageUrl:
            '${server.url}/Users/${userJellyfin!.id}/Images/Primary?quality=90',
        width: size,
        errorWidget: (context, url, error) => Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          child: Icon(Icons.person_off),
        ),
      ),
    );
  }
}
