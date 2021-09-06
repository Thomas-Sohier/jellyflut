part of '../fields.dart';

class TagsField extends StatelessWidget {
  final Item item;
  final FormGroup form;
  final double ITEM_HEIGHT = 35;

  const TagsField({Key? key, required this.form, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Tags', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 24),
        SizedBox(
            width: double.maxFinite,
            child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 10,
                children: generateAllTags(context))),
      ],
    );
  }

  List<Widget> generateAllTags(BuildContext context) {
    if (item.tags == null) return [];
    return item.tags!.map((dynamic tag) => tagItem(tag, context)).toList();
  }

  Widget tagItem(String? tag, BuildContext context) {
    if (tag == null) return SizedBox();
    return Container(
        height: ITEM_HEIGHT,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.all(Radius.circular(ITEM_HEIGHT))),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(tag.capitalize())),
                IconButton(
                    onPressed: () => {},
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.remove_circle_outline,
                      size: 16,
                      color: Colors.white,
                    ))
              ],
            )));
  }
}
