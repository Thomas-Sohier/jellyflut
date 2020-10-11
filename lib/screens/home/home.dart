import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/collection.dart';
import 'package:jellyflut/screens/home/collectionHome.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // bottomNavigationBar: BottomBar(),
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
                    tag: "logo",
                    child: Image(
                      image: AssetImage('img/jellyfin_logo.png'),
                      width: 40.0,
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                ),
                Hero(
                  tag: "logo_text",
                  child: Text(
                    "Jellyfin",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),
            FutureBuilder<Category>(
              future: getCategory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> children = new List();
                  snapshot.data.items.forEach((Item item) {
                    children.add(CollectionHome(item));
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: children,
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ))));
  }
}
