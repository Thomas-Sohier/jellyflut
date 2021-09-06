part of '../fields.dart';

class PersonField extends StatelessWidget {
  final Item item;
  final FormGroup form;
  final double ITEM_HEIGHT = 100;

  const PersonField({Key? key, required this.form, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Persons', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 24),
        SizedBox(
          height: (ITEM_HEIGHT * (item.people?.length ?? 0)).toDouble(),
          width: double.maxFinite,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: item.people?.length ?? 0,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => PersonItem(
                person: item.people?.elementAt(index),
                height: ITEM_HEIGHT,
                onPressed: () => {}),
          ),
        ),
      ],
    );
  }
}
