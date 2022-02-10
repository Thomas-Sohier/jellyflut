part of '../fields.dart';

class PersonField extends StatefulWidget {
  final Item item;
  final FormGroup form;
  final double ITEM_HEIGHT = 80;

  const PersonField({Key? key, required this.form, required this.item})
      : super(key: key);

  @override
  _PersonFieldState createState() => _PersonFieldState();
}

class _PersonFieldState extends State<PersonField> {
  late final Item item;
  late final FormGroup form;
  late final double ITEM_HEIGHT;

  @override
  void initState() {
    item = widget.item;
    form = widget.form;
    ITEM_HEIGHT = widget.ITEM_HEIGHT;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Persons', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 24),
        SizedBox(
          height:
              (ITEM_HEIGHT * (item.people.isNotEmpty ? item.people.length : 0))
                  .toDouble(),
          width: double.maxFinite,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: item.people.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => PersonItem(
                  person: item.people.elementAt(index),
                  height: ITEM_HEIGHT,
                  onPressed: () => setState(() {
                        item.people.removeAt(index);
                      }))),
        ),
      ],
    );
  }
}
