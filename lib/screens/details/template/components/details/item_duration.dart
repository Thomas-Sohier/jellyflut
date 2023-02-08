import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/screens/details/template/components/details/details_separator.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ItemDuration extends StatelessWidget {
  static final DateFormat formatter = DateFormat('HH:mm');
  final Item item;
  const ItemDuration({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final timeEnd = formatter.format(DateTime.now().add(Duration(microseconds: item.getDuration())));
    final duration = printDuration(Duration(microseconds: item.getDuration()));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(duration, style: Theme.of(context).textTheme.bodyMedium),
        const DetailsSeparator(),
        Text('item_ends'.tr(args: [timeEnd]), style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
