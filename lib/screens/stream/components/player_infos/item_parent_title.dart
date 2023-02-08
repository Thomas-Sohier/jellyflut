part of 'player_infos.dart';

class ItemParentTitle extends StatelessWidget {
  const ItemParentTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.read<StreamCubit>().state.streamItem.item.parentName(),
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(foreground: Paint()..shader = CustomGradient(context).linearGradient)
            .copyWith(fontWeight: FontWeight.w600));
  }
}
