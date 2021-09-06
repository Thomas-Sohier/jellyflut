import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsSeparator extends StatelessWidget {
  const DetailsSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Text('|', style: Theme.of(context).textTheme.bodyText2),
    );
  }
}
