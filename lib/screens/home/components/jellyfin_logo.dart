import 'package:flutter/widgets.dart';

class JellyfinLogo extends StatelessWidget {
  const JellyfinLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('img/jellyfin_logo.png'),
      width: 40.0,
    );
  }
}
