part of '../fields.dart';

class PersonField extends StatelessWidget {
  final Item item;
  final FormGroup form;
  final double ITEM_HEIGHT = 100;

  const PersonField({Key? key, required this.form, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (ITEM_HEIGHT * (item.people?.length ?? 0)).toDouble(),
      width: double.maxFinite,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: item.people?.length ?? 0,
        itemBuilder: (context, index) =>
            personItem(item.people?.elementAt(index), index),
      ),
    );
  }

  Widget personItem(Person? person, int index) {
    if (person == null) return SizedBox();
    return SizedBox(
      height: ITEM_HEIGHT,
      child: Row(children: [
        PeoplePoster(person: person, index: index, onPressed: () => {}),
        Expanded(child: Text(person.name)),
      ]),
    );
  }
}
