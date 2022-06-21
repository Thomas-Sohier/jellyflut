part of 'player_infos.dart';

class ItemParentTitle extends StatelessWidget {
  const ItemParentTitle({super.key});

  StreamingProvider get streamingProvider => StreamingProvider();

  @override
  Widget build(BuildContext context) {
    return Text(streamingProvider.item!.parentName(),
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(
                foreground: Paint()
                  ..shader = CustomGradient(context).linearGradient)
            .copyWith(fontWeight: FontWeight.w600));
  }
}
