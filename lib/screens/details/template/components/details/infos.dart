part of '../details_widgets.dart';

class InfosDetailsWidget extends StatelessWidget {
  final Item item;

  const InfosDetailsWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final listOfText = <String?>[
      item.productionYear.toString(),
      duration(),
      endTime()
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: generateInfosWithSeparator(listOfText, context),
      ),
    );
  }

  String? duration() {
    if (item.getDuration() == 0) return null;
    final duration = printDuration(Duration(microseconds: item.getDuration()));
    return duration.toString();
  }

  String? endTime() {
    if (item.getDuration() == 0) return null;

    final formatter = DateFormat('HH:mm');
    final timeEnd = formatter
        .format(DateTime.now().add(Duration(microseconds: item.getDuration())));
    return 'item_ends'.tr(args: [timeEnd]);
  }

  List<Widget> generateInfosWithSeparator(
      List<String?> listOfText, BuildContext context) {
    return listOfText
        .where((t) => t != null && t.isNotEmpty && t != 'null')
        .map((e) => [
              Text(e!, style: Theme.of(context).textTheme.subtitle1),
              DetailsSeparator()
            ])
        .fold<List<Widget>>([const SizedBox()],
            (previousValue, element) => previousValue..addAll(element))
      ..removeLast()
      ..toList();
  }
}
