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
            itemBuilder: (context, index) =>
                personItem(item.people?.elementAt(index), index, context),
          ),
        ),
      ],
    );
  }

  Widget personItem(Person? person, int index, BuildContext context) {
    if (person == null) return SizedBox();
    final headlineColor = Theme.of(context).textTheme.headline6!.color;
    return SizedBox(
      height: ITEM_HEIGHT,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PeoplePoster(person: person, index: index, clickable: false),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(person.name,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.headline6),
                    Text(
                      person.role,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 16)
                          .copyWith(color: headlineColor!.withAlpha(180)),
                    ),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () => item.people?.removeAt(index),
                  hoverColor: Colors.red.withOpacity(0.1),
                  icon: Icon(Icons.delete_outline, color: Colors.red))
            ]),
      ),
    );
  }
}
