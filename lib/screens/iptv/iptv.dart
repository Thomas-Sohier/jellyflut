import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/iptv/iptv_programs.dart';

class Iptv extends StatefulWidget {
  Iptv({Key? key}) : super(key: key);

  @override
  _IptvState createState() => _IptvState();
}

class _IptvState extends State<Iptv> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Center(child: IptvPrograms())),
      ],
    );
  }
}
