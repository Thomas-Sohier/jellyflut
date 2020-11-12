import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/models/person.dart';
import 'package:jellyflut/shared/theme.dart';

class PeoplesList extends StatefulWidget {
  final List<Person> peoples;

  const PeoplesList(this.peoples);

  @override
  State<StatefulWidget> createState() => _PeoplesListState();
}

class _PeoplesListState extends State<PeoplesList> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: [Expanded(child: listPeoples(widget.peoples))]);
  }
}

Widget listPeoples(List<Person> peoples) {
  return ListView.builder(
    itemCount: peoples.length,
    scrollDirection: Axis.horizontal,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      var people = peoples[index];
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 8,
                child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: AsyncImage(
                          people.id,
                          people.primaryImageTag,
                          people.imageBlurHashes,
                          boxFit: BoxFit.contain,
                          placeholder: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Icon(Icons.person),
                            ),
                          ),
                        )))),
            Flexible(
                flex: 1,
                child: Text(
                  people.name ?? '-',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
            Flexible(
                flex: 1,
                child: Text(
                  people.role ?? '-',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ))
          ],
        ),
      );
    },
  );
}
