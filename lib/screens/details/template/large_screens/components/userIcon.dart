import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';

class UserIcon extends StatelessWidget {
  final double size;

  const UserIcon({Key? key, this.size = 28}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          child: CachedNetworkImage(
            imageUrl:
                '${server.url}/Users/${userJellyfin!.id}/Images/Primary?quality=90',
            width: size,
          ),
        ));
  }
}
