import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeCategoryTitle extends StatefulWidget {
  HomeCategoryTitle(this.categoryTitle, {required this.onTap});

  final String categoryTitle;
  final VoidCallback onTap;

  @override
  State<HomeCategoryTitle> createState() => _HomeCategoryTitleState();
}

class _HomeCategoryTitleState extends State<HomeCategoryTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
        child: Row(children: [
          Expanded(
            child: Text(
              widget.categoryTitle.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ]));
  }
}
