import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';

extension EnumExtension on Enum {
  String getValue() {
    final value = this;
    return value.toString().substring(value.toString().indexOf('.') + 1);
  }

  String getName() {
    final value = this;
    return fieldsEnumValues.map.keys.elementAt(value.index);
  }
}
