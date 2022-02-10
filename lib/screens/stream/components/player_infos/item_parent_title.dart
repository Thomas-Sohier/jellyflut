part of 'player_infos.dart';

class ItemParentTitle extends StatelessWidget {
  final StreamingProvider streamingProvider = StreamingProvider();

  ItemParentTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      streamingProvider.item!.parentName(),
      textAlign: TextAlign.left,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          foreground: Paint()..shader = CustomGradient(context).linearGradient,
          fontSize: 14),
    );
  }
}
