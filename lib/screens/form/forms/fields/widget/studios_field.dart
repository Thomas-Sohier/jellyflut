part of '../fields.dart';

class StudiosField extends StatefulWidget {
  final Item item;
  final FormGroup form;
  final double ITEM_HEIGHT = 40;

  const StudiosField({Key? key, required this.form, required this.item})
      : super(key: key);

  @override
  _StudiosFieldState createState() => _StudiosFieldState();
}

class _StudiosFieldState extends State<StudiosField> {
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
        Text('Studios', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 24),
        SizedBox(
          height: (ITEM_HEIGHT * (item.studios.length)).toDouble(),
          width: double.maxFinite,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: item.studios.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                studioItem(item.studios.elementAt(index).name, index, context),
          ),
        ),
      ],
    );
  }

  Widget studioItem(String? name, int index, BuildContext context) {
    if (name == null) return SizedBox();
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
                child: Text(name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: headlineColor!.withAlpha(210))),
              ),
              Spacer(),
              IconButton(
                  onPressed: () => setState(() {
                        item.studios.removeAt(index);
                      }),
                  hoverColor: Colors.red.withOpacity(0.1),
                  icon: Icon(Icons.delete_outline, color: Colors.red))
            ]),
      ),
    );
  }
}
