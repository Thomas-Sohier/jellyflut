part of 'player_infos.dart';

class ItemTitle extends StatelessWidget {
  const ItemTitle({super.key});

  StreamingProvider get streamingProvider => StreamingProvider();

  @override
  Widget build(BuildContext context) {
    if (streamingProvider.item == null) return SizedBox();
    return Text(
      streamingProvider.item!.name,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style:
          Theme.of(context).textTheme.headline3?.copyWith(color: Colors.white),
    );
  }
}
