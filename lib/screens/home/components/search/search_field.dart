import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/home/components/search/search_rest_call.dart';

class SearchField extends StatelessWidget {
  final Icon? icon;
  final Color? fieldColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final TextEditingController textEditingController;

  const SearchField({
    super.key,
    required this.textEditingController,
    this.icon,
    this.fieldColor = Colors.transparent,
    this.padding,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderSide: BorderSide(width: 0, color: Colors.transparent, style: BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(4)));

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event.runtimeType == RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          searchItemsFuture(textEditingController.text, context.read<ItemsRepository>());
        }
      },
      child: TextFormField(
        controller: textEditingController,
        minLines: 1,
        maxLines: 1,
        decoration: InputDecoration(
          constraints: constraints,
          border: border,
          errorBorder: border,
          enabledBorder: border,
          focusedBorder: border,
          disabledBorder: border,
          focusedErrorBorder: border,
          filled: true,
          fillColor: fieldColor,
          hoverColor: fieldColor,
          suffixIcon: icon,
          contentPadding: padding,
          hintText: 'Your search here...',
        ),
      ),
    );
  }
}
