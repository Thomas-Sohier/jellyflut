part of 'player_infos.dart';

class ItemParentTitle extends StatelessWidget {
  final StreamingProvider streamingProvider = StreamingProvider();

  ItemParentTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (streamingProvider.item == null || streamingProvider.item!.hasParent()) {
      return SizedBox();
    }
    return Text(
      streamingProvider.item!.parentName(),
      textAlign: TextAlign.left,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          foreground: Paint()..shader = linearGradient,
          fontSize: 14),
    );
  }
}
