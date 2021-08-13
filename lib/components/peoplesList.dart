import 'package:flutter/material.dart';
import 'package:jellyflut/components/peoplePoster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/imageTags.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/itemType.dart';
import 'package:jellyflut/models/person.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PeoplesList extends StatefulWidget {
  final List<Person> persons;
  final Color fontColor;

  const PeoplesList(this.persons, {this.fontColor = Colors.black});

  @override
  State<StatefulWidget> createState() => _PeoplesListState();
}

class _PeoplesListState extends State<PeoplesList> {
  late Color fontColor;

  @override
  void initState() {
    fontColor = widget.fontColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: [Expanded(child: listPeoples(widget.persons))]);
  }

  Widget listPeoples(List<Person> peoples) {
    return ListView.builder(
        itemCount: peoples.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          var person = peoples[index];
          var item = Item(
              name: person.name,
              id: person.id,
              imageBlurHashes: person.imageBlurHashes,
              imageTags: ImageTags(primary: person.primaryImageTag),
              type: ItemType.PERSON);
          return ScreenTypeLayout.builder(
              breakpoints: screenBreakpoints,
              mobile: (BuildContext context) =>
                  phonePoster(item, person, index),
              tablet: (BuildContext context) =>
                  largeScreenTemplate(item, person, index),
              desktop: (BuildContext context) =>
                  largeScreenTemplate(item, person, index));
        });
  }

  Widget phonePoster(Item item, Person person, int index) {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: InkWell(
            onTap: () => onTap(item, person),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    flex: 5,
                    child: PeoplePoster(
                        person: person,
                        index: index,
                        onPressed: () => onTap(item, person))),
                Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      person.name,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: TextStyle(
                          color: fontColor.withAlpha(240), fontSize: 16),
                    )),
                Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      person.role,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: TextStyle(
                          color: fontColor.withAlpha(200), fontSize: 12),
                    ))
              ],
            )));
  }

  Widget largeScreenTemplate(Item item, Person person, int index) {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () => onTap(item, person),
          child: PeoplePoster(
              person: person,
              index: index,
              bigPoster: true,
              onPressed: () => onTap(item, person)),
        ));
  }

  void onTap(Item item, Person person) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Details(item: item, heroTag: '${person.id}-person')));
  }
}
