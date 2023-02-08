part of '../fields.dart';

class GenresField extends StatelessWidget {
  static const double ITEM_HEIGHT = 40;

  const GenresField({super.key});
  @override
  Widget build(BuildContext context) {
    final item = context.read<FormBloc>().state.item;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Genres', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 24),
        SizedBox(
          height: (ITEM_HEIGHT * (item.genreItems.length)).toDouble(),
          width: double.maxFinite,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: item.genreItems.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => genreItem(item.genreItems.elementAt(index), index, context),
          ),
        ),
      ],
    );
  }

  Widget genreItem(NamedGuidPair? genreItem, int index, BuildContext context) {
    if (genreItem == null) return SizedBox();
    final headlineColor = Theme.of(context).textTheme.titleLarge!.color;
    return SizedBox(
      height: ITEM_HEIGHT,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child:
            Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Text(genreItem.name ?? '',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: headlineColor!.withAlpha(210))),
          ),
          Spacer(),
          IconButton(
              onPressed: () => context.read<FormBloc>().state.item.genreItems.removeAt(index),
              hoverColor: Colors.red.withOpacity(0.1),
              icon: Icon(Icons.delete_outline, color: Colors.red))
        ]),
      ),
    );
  }
}
