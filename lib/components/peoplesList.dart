import 'package:flutter/material.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/models/imageTags.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/person.dart';
import 'package:jellyflut/screens/details/details.dart';

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
      var item = Item(
          name: people.name,
          id: people.id,
          imageBlurHashes: people.imageBlurHashes,
          imageTags: ImageTags(primary: people.primaryImageTag),
          type: 'Person');
      return Container(
        width: 100,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Details(item: item, heroTag: '${people.id}-person'))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    flex: 5,
                    child: Hero(
                      tag: '${people.id}-person',
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
                          )),
                    )),
                Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      people.name ?? '-',
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      people.role ?? '-',
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ))
              ],
            )),
      );
    },
  );
}
