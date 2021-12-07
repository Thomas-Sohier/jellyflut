import 'package:flutter/foundation.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';

extension EnumExtension on Enum {
  String getValue() {
    return describeEnum(this);
  }

  String getName() {
    // TODO hardcoded enum fields value, change to something better or rework forms
    return fieldsEnumValues.map.keys.elementAt(index);
  }
}
