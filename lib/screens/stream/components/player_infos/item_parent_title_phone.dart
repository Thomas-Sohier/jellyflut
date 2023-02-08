part of 'player_infos.dart';

class ItemParentTitlePhone extends StatelessWidget {
  const ItemParentTitlePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.read<StreamCubit>().state.streamItem.item.parentName(),
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(foreground: Paint()..shader = CustomGradient(context).linearGradient)
            .copyWith(fontWeight: FontWeight.w600));
  }
}
