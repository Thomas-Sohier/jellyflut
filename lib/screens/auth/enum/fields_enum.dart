import 'package:jellyflut/models/enum/enum_values.dart';

enum FieldsType {
  SERVER_NAME,
  SERVER_URL,
  USER_USERNAME,
  USER_PASSWORD,
}

final fieldsTypeValues = EnumValues({
  'server_name': FieldsType.SERVER_NAME,
  'server_url': FieldsType.SERVER_URL,
  'user_username': FieldsType.USER_USERNAME,
  'user_password': FieldsType.USER_PASSWORD
});
