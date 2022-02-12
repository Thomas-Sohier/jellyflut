import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final Icon? icon;
  final Color? fieldColor;
  final EdgeInsets? padding;
  final TextEditingController? textEditingController;

  const SearchField(
      {Key? key,
      this.icon,
      this.fieldColor = Colors.transparent,
      this.padding,
      this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderSide: BorderSide(
            width: 0, color: Colors.transparent, style: BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(4)));

    return TextFormField(
      controller: textEditingController,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
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
    );
  }
}
