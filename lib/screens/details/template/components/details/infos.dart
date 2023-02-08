part of '../details_widgets.dart';

class InfosDetailsWidget extends StatelessWidget {
  const InfosDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    final listOfText = <String?>[
      state.item.productionYear.toString(),
      duration(state.item),
      endTime(state.item),
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

  String? duration(Item item) {
    if (item.getDuration() == 0) return null;
    final duration = printDuration(Duration(microseconds: item.getDuration()));
    return duration.toString();
  }

  String? endTime(Item item) {
    if (item.getDuration() == 0) return null;

    final formatter = DateFormat('HH:mm');
    final timeEnd = formatter.format(DateTime.now().add(Duration(microseconds: item.getDuration())));
    return 'item_ends'.tr(args: [timeEnd]);
  }

  List<Widget> generateInfosWithSeparator(List<String?> listOfText, BuildContext context) {
    return listOfText
        .where((t) => t != null && t.isNotEmpty && t != 'null')
        .map((e) => [Text(e!, style: Theme.of(context).textTheme.titleMedium), DetailsSeparator()])
        .fold<List<Widget>>([const SizedBox()], (previousValue, element) => previousValue..addAll(element))
      ..removeLast()
      ..toList();
  }
}
