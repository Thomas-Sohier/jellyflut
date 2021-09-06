import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/details/details_seprator.dart';
import 'package:jellyflut/shared/shared.dart';

class ItemDuration extends StatelessWidget {
  static final DateFormat formatter = DateFormat('HH:mm');
  final Item item;
  const ItemDuration({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeEnd = formatter
        .format(DateTime.now().add(Duration(microseconds: item.getDuration())));
    final duration = printDuration(Duration(microseconds: item.getDuration()));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(duration, style: Theme.of(context).textTheme.bodyText2),
        const DetailsSeparator(),
        Text('Ends $timeEnd', style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }
}
