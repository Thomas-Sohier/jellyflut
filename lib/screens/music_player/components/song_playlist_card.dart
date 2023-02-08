import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SongPlaylistCard extends StatelessWidget {
  final Widget child;
  const SongPlaylistCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12),
        child: DecoratedBox(
            decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).cardTheme.shadowColor ?? Colors.black38,
                    blurRadius: 6,
                    spreadRadius: 2,
                  )
                ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('playlist'.tr(),
                        textAlign: TextAlign.left, style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  Expanded(child: child)
                ])));
  }
}
