part of '../fields.dart';

class StudiosField extends StatelessWidget {
  final Item item;
  final FormGroup form;
  final double ITEM_HEIGHT = 50;

  const StudiosField({Key? key, required this.form, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Studios', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 24),
        SizedBox(
          height: (ITEM_HEIGHT * (item.studios?.length ?? 0)).toDouble(),
          width: double.maxFinite,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: item.studios?.length ?? 0,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                studioItem(item.studios?.elementAt(index), index, context),
          ),
        ),
      ],
    );
  }

  Widget studioItem(GenreItem? genreItem, int index, BuildContext context) {
    if (genreItem == null) return SizedBox();
    final headlineColor = Theme.of(context).textTheme.headline6!.color;
    return SizedBox(
      height: ITEM_HEIGHT,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(genreItem.name!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: headlineColor!.withAlpha(210))),
              ),
              Spacer(),
              IconButton(
                  onPressed: () => item.studios?.removeAt(index),
                  hoverColor: Colors.red.withOpacity(0.1),
                  icon: Icon(Icons.delete_outline, color: Colors.red))
            ]),
      ),
    );
  }
}
