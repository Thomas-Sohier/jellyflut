part of 'player_infos.dart';

class ItemTitle extends StatelessWidget {
  const ItemTitle({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<StreamCubit>().state.streamItem.item.isEmpty) {
      return SizedBox();
    }
    return Text(
      context.read<StreamCubit>().state.streamItem.item.name ?? '',
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
    );
  }
}
