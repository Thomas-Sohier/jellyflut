part of 'player_infos.dart';

class ItemTitlePhone extends StatelessWidget {
  const ItemTitlePhone({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<StreamCubit>().state.streamItem.item.isEmpty) {
      return SizedBox();
    }
    return Text(
      context.read<StreamCubit>().state.streamItem.item.name ?? '',
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(color: Theme.of(context).colorScheme.onBackground)
          .copyWith(fontSize: 20),
    );
  }
}
