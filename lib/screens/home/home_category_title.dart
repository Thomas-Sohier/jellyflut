import 'package:flutter/material.dart';

class HomeCategoryTitle extends StatefulWidget {
  HomeCategoryTitle(this.categoryTitle, {required this.onTap});

  final String categoryTitle;
  final VoidCallback onTap;

  @override
  _HomeCategoryTitleState createState() => _HomeCategoryTitleState();
}

class _HomeCategoryTitleState extends State<HomeCategoryTitle> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        widget.categoryTitle,
        style: TextStyle(color: Colors.white, fontSize: 28),
      )
    ]);
  }
}
