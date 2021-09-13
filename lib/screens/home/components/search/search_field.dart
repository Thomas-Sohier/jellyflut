import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/home/components/search/search_rest_call.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onFieldSubmitted: (String value) => searchItemsFuture(value),
        textInputAction: TextInputAction.search,
        cursorColor: Colors.white,
        enabled: true,
        maxLines: 1,
        decoration: InputDecoration(
            labelText: 'search_field_hint'.tr(),
            labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            isDense: true,
            border: DEFAULT_BORDER,
            enabledBorder: DEFAULT_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}

final InputBorder DEFAULT_BORDER = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(4)));
final InputBorder FOCUSED_BORDER = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(4)));
