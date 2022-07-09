part of '../fields.dart';

class PersonField extends StatelessWidget {
  static const double ITEM_HEIGHT = 80;

  const PersonField({super.key});

  @override
  Widget build(BuildContext context) {
    final item = context.read<FormBloc>().state.item;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Persons', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 24),
        SizedBox(
          height: (ITEM_HEIGHT * (item.people.isNotEmpty ? item.people.length : 0)).toDouble(),
          width: double.maxFinite,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: item.people.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => PersonItem(
                  person: item.people.elementAt(index),
                  height: ITEM_HEIGHT,
                  onPressed: () => item.people.removeAt(index))),
        ),
      ],
    );
  }
}
