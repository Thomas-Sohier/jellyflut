part of '../fields.dart';

class StudiosField extends StatelessWidget {
  static const double ITEM_HEIGHT = 40;

  const StudiosField({super.key});

  @override
  Widget build(BuildContext context) {
    final item = context.read<FormBloc>().state.item;
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
            itemBuilder: (context, index) => studioItem(item.studios.elementAt(index).name, index, context),
          ),
        ),
      ],
    );
  }

  Widget studioItem(String? name, int index, BuildContext context) {
    if (name == null) return SizedBox();
    final headlineColor = Theme.of(context).textTheme.titleLarge!.color;
    return SizedBox(
      height: ITEM_HEIGHT,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child:
            Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Text(name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: headlineColor!.withAlpha(210))),
          ),
          Spacer(),
          IconButton(
              onPressed: () => context.read<FormBloc>().state.item.studios.removeAt(index),
              hoverColor: Colors.red.withOpacity(0.1),
              icon: Icon(Icons.delete_outline, color: Colors.red))
        ]),
      ),
    );
  }
}
