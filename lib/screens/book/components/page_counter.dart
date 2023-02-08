import 'package:flutter/material.dart';

class PageCounter extends StatelessWidget {
  final int? currentPage;
  final int? nbPages;
  const PageCounter({super.key, required this.currentPage, required this.nbPages});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: 50,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text('${currentPage ?? '∞'}',
                maxLines: 1, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
              height: 1,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            Text('${nbPages ?? '∞'}', maxLines: 1, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
          ])),
    );
  }
}
