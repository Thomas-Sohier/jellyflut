part of 'player_infos.dart';

class ItemTitle extends StatelessWidget {
  final StreamingProvider streamingProvider = StreamingProvider();

  ItemTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (streamingProvider.item == null) return SizedBox();
    return Text(
      streamingProvider.item!.name,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
    );
  }
}
