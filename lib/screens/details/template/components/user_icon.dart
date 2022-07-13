import 'package:authentication_repository/authentication_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserIcon extends StatelessWidget {
  final double size;
  const UserIcon({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<AuthenticationRepository>();
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: CachedNetworkImage(
        imageUrl: '${authRepo.currentServer.url}/Users/${authRepo.currentUser.id}/Images/Primary?quality=90',
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
