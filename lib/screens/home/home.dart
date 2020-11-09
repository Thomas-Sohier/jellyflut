import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/home/collectionHome.dart';
import 'package:jellyflut/screens/home/resume.dart';
import 'package:provider/provider.dart';

import 'background.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
        create: (context) => MusicPlayer(),
        child: Scaffold(
            floatingActionButton: MusicPlayerFAB(),
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: Background(
                child: SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                        tag: 'logo',
                        child: Image(
                          image: AssetImage('img/jellyfin_logo.png'),
                          width: 40.0,
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                    ),
                    Hero(
                      tag: 'logo_text',
                      child: Text(
                        'Jellyfin',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Resume(),
                FutureBuilder<Category>(
                  future: getCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return buildCategory(snapshot.data);
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(height: size.height * 0.05),
              ],
            )))));
  }
}

Widget buildCategory(Category category) {
  return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      itemCount: category.items.length,
      itemBuilder: (context, index) {
        var _item = category.items[index];
        return CollectionHome(_item);
      });
}
